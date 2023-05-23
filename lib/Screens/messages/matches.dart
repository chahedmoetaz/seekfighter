import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seekfighter/Models/user.dart';
import 'package:seekfighter/Widgets/pageTurn.dart';
import 'package:seekfighter/bloc/matches/matches_bloc.dart';
import 'package:seekfighter/bloc/matches/matches_event.dart';
import 'package:seekfighter/bloc/matches/matches_state.dart';
import 'package:seekfighter/components/iconWidget.dart';
import 'package:seekfighter/components/profile.dart';
import 'package:seekfighter/components/userGender.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/services/matchesRepository.dart';

import 'messaging.dart';

class Matches extends StatefulWidget {
  final String userId;

  const Matches({this.userId});

  @override
  _MatchesState createState() => _MatchesState();
}

class _MatchesState extends State<Matches> {
  MatchesRepository matchesRepository = MatchesRepository();
  MatchesBloc _matchesBloc;

  int difference;

  getDifference(GeoPoint userLocation) async {
    Position position = await Geolocator.getCurrentPosition();

    double location = await Geolocator.distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);

    difference = location.toInt();
  }

  @override
  void initState() {
    _matchesBloc = MatchesBloc(matchesRepository: matchesRepository);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<MatchesBloc, MatchesState>(
      bloc: _matchesBloc,
      builder: (BuildContext context, MatchesState state) {
        if (state is LoadingState) {
          _matchesBloc.add(LoadListsEvent(userId: widget.userId));
          return CircularProgressIndicator();
        }
        if (state is LoadUserState) {
          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                backgroundColor: kBackgroundColor,
                title: Center(
                  child: Text(
                    "Matched User",
                    style: TextStyle(color: Colors.black, fontSize: 30.0),
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: state.matchedList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                  if (snapshot.data.documents != null) {
                    final user = snapshot.data.documents;

                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              User selectedUser = await matchesRepository
                                  .getUserDetails(user[index].documentID);
                              User currentUser = await matchesRepository
                                  .getUserDetails(widget.userId);
                              await getDifference(GeoPoint(selectedUser.lat,selectedUser.lon));
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: profileWidget(
                                    photo: selectedUser.profilePictureURL,
                                    photoHeight: size.height,
                                    padding: size.height * 0.01,
                                    photoWidth: size.width,
                                    clipRadius: size.height * 0.01,
                                    containerWidth: size.width,
                                    containerHeight: size.height * 0.2,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.height * 0.02),
                                      child: ListView(
                                        children: <Widget>[
                                          SizedBox(
                                            height: size.height * 0.02,
                                          ),
                                          Row(
                                            children: <Widget>[
                                              userGender(selectedUser.gender),
                                              Expanded(
                                                child: Text(
                                                  " " +
                                                      selectedUser.firstName +
                                                      ", " +

                                                              selectedUser.age
                                                          .toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize:
                                                          size.height * 0.05),
                                                ),
                                              )
                                            ],
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                difference != null
                                                    ? (difference / 1000)
                                                            .floor()
                                                            .toString() +
                                                        " km away"
                                                    : "away",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: size.height * 0.01,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Padding(
                                                padding: EdgeInsets.all(
                                                    size.height * 0.02),
                                                child: iconWidget(Icons.message,
                                                    () {
                                                  _matchesBloc.add(
                                                    OpenChatEvent(
                                                        currentUser:
                                                            widget.userId,
                                                        selectedUser:
                                                            selectedUser.userID),
                                                  );
                                                  pageTurn(
                                                      Messaging(
                                                          currentUser:
                                                              currentUser,
                                                          selectedUser:
                                                              selectedUser),
                                                      context);
                                                }, size.height * 0.04,
                                                    Colors.white),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: profileWidget(
                              padding: size.height * 0.01,
                              photo: user[index].data['photo'],
                              photoWidth: size.width * 0.5,
                              photoHeight: size.height * 0.3,
                              clipRadius: size.height * 0.01,
                              containerHeight: size.height * 0.03,
                              containerWidth: size.width * 0.5,
                              child: Text(
                                "  " + user[index].data['firstName'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        childCount: user.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                },
              ),
              SliverAppBar(
                backgroundColor: kBackgroundColor,
                pinned: true,
                title: Text(
                  "Someone Likes You",
                  style: TextStyle(color: Colors.black, fontSize: 30),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: state.selectedList,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                  }
                  if (snapshot.data.documents != null) {
                    final user = snapshot.data.documents;
                    return SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () async {
                              User selectedUser = await matchesRepository
                                  .getUserDetails(user[index].documentID);
                              User currentUser = await matchesRepository
                                  .getUserDetails(widget.userId);

                              await getDifference(GeoPoint(selectedUser.lat,selectedUser.lon));
                              // ignore: missing_return
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: profileWidget(
                                    padding: size.height * 0.01,
                                    photo: selectedUser.profilePictureURL,
                                    photoHeight: size.height,
                                    photoWidth: size.width,
                                    clipRadius: size.height * 0.01,
                                    containerWidth: size.width,
                                    containerHeight: size.height * 0.2,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: size.height * 0.02),
                                      child: Column(
                                        children: <Widget>[
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: size.height * 0.01,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    userGender(
                                                        selectedUser.gender),
                                                    Expanded(
                                                      child: Text(
                                                        " " +
                                                            selectedUser.firstName +
                                                            ", " +

                                                                    selectedUser
                                                                        .age

                                                                .toString(),
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize:
                                                                size.height *
                                                                    0.05),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.location_on,
                                                      color: Colors.white,
                                                    ),
                                                    Text(
                                                      difference != null
                                                          ? (difference / 1000)
                                                                  .floor()
                                                                  .toString() +
                                                              " km away"
                                                          : "away",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: size.height * 0.01,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    iconWidget(Icons.clear, () {
                                                      _matchesBloc.add(
                                                        DeleteUserEvent(
                                                            currentUser:
                                                                currentUser.userID,
                                                            selectedUser:
                                                                selectedUser
                                                                    .userID),
                                                      );
                                                      Navigator.of(context)
                                                          .pop();
                                                    }, size.height * 0.08,
                                                        Colors.blue),
                                                    SizedBox(
                                                      width: size.width * 0.05,
                                                    ),
                                                    iconWidget(
                                                        FontAwesomeIcons
                                                            .solidHeart, () {
                                                      _matchesBloc.add(
                                                        AcceptUserEvent(
                                                            selectedUser:
                                                                selectedUser
                                                                    .userID,
                                                            currentUser:
                                                                currentUser.userID,
                                                            currentUserPhotoUrl:
                                                                currentUser
                                                                    .profilePictureURL,
                                                            currentUserName:
                                                                currentUser
                                                                    .firstName,
                                                            selectedUserPhotoUrl:
                                                                selectedUser
                                                                    .profilePictureURL,
                                                            selectedUserName:
                                                                selectedUser
                                                                    .firstName),
                                                      );
                                                      Navigator.of(context)
                                                          .pop();
                                                    }, size.height * 0.06,
                                                        Colors.red),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: profileWidget(
                              padding: size.height * 0.01,
                              photo: user[index].data['photo'],
                              photoWidth: size.width * 0.5,
                              photoHeight: size.height * 0.3,
                              clipRadius: size.height * 0.01,
                              containerHeight: size.height * 0.03,
                              containerWidth: size.width * 0.5,
                              child: Text(
                                "  " + user[index].data['firstName'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        },
                        childCount: user.length,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                    );
                  } else
                    return SliverToBoxAdapter(
                      child: Container(),
                    );
                },
              ),
            ],
          );
        }
        return Container();
      },
    );
  }
}
