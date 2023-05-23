import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:seekfighter/Models/user.dart';
import 'package:seekfighter/Screens/detail_profile/detail_profile_screen.dart';
import 'package:seekfighter/bloc/search/bloc.dart';
import 'package:seekfighter/components/iconWidget.dart';
import 'package:seekfighter/components/profile.dart';
import 'package:seekfighter/components/userGender.dart';
import 'package:seekfighter/constants/constants.dart';
import 'package:seekfighter/constants/size_config.dart';
import 'package:seekfighter/services/searchRepository.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class TinderTab extends StatefulWidget {
  final String userId;

  const TinderTab({this.userId});

  @override
  _TinderTabState createState() => _TinderTabState();
}

class _TinderTabState extends State<TinderTab> {
  final SearchRepository _searchRepository = SearchRepository();
  SearchBloc _searchBloc;
  User _user, _currentUser;
  int difference;

  getDifference(GeoPoint userLocation) async {
    Position position = await Geolocator.getCurrentPosition();

    double location = Geolocator.distanceBetween(userLocation.latitude,
        userLocation.longitude, position.latitude, position.longitude);
    setState(() {
      difference = location.toInt();
    });

  }

  @override
  void initState() {
    _searchBloc = SearchBloc(searchRepository: _searchRepository);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(
      bloc: _searchBloc,
      builder: (context, state) {
        if (state is InitialSearchState) {
          _searchBloc.add(
            LoadUserEvent(userId: widget.userId),
          );
          return Center(
            child: SpinKitRing(
              color: kPrimaryColor,
              size: 30,
              lineWidth: 4,
            ),
          );
        }
        if (state is LoadingState) {
          return Center(
            child: SpinKitRing(
              color: kPrimaryColor,
              size: 30,
              lineWidth: 4,
            ),
          );
        }
        if (state is LoadUserState) {
          _user = state.user ;
          _currentUser = state.currentUser;

          getDifference(GeoPoint(_user.lat,_user.lon));
          if (_user.lat == null) {
            return Center(
              child: Text(
                "No One Here",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            );
          } else
            return profileWidget(
              padding: size.height * 0.035,
              photoHeight: size.height * 0.824,
              photoWidth: size.width * 0.95,
              photo: _user.profilePictureURL,
              searchfor: _user.searchfor,
              clipRadius: size.height * 0.02,
              containerHeight: size.height * 0.3,
              containerWidth: size.width * 0.9,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: size.height * 0.06,
                    ),
                    Row(
                      children: <Widget>[
                        userGender(_user.gender),
                        Expanded(
                          child: Text(
                            " " +
                                _user.firstName +
                                ", " +
                                 _user.age
                                    .toString(),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.height * 0.05),
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
                              ? (difference / 1000).floor().toString() +
                              "km away"
                              : "away",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),

                    SizedBox(
                      height: getProportionateScreenWidth(5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        iconWidget(Icons.clear, () {
                          _searchBloc
                              .add(PassUserEvent(widget.userId, _user.userID));
                        }, size.height * 0.08, Colors.redAccent),
                        iconWidget(FontAwesomeIcons.solidHeart, () {
                          _searchBloc.add(
                            SelectUserEvent(
                                name: _currentUser.firstName,
                                photoUrl: _currentUser.profilePictureURL,
                                currentUserId: widget.userId,
                                selectedUserId: _user.userID),
                          );
                        }, size.height * 0.06, Colors.green),
                        iconWidget(EvaIcons.info, () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailProfileScreen(uid: _user.userID,difference:difference)));
                        }, size.height * 0.04,
                            Colors.white)
                      ],
                    )
                  ],
                ),
              ),
            );
        } else
          return Container();
      },
    );
  }
}
