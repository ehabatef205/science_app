import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:science/screens/auth/login_screen.dart';
import 'package:science/screens/home/user/details_screen.dart';
import 'package:science/screens/home/user/feature_job_screen.dart';
import 'package:science/screens/home/user/settings/applications_screen.dart';
import 'package:science/screens/home/user/settings/saved_screen.dart';
import 'package:science/screens/home/user/settings/settings_screen.dart';
import 'package:science/screens/home/user/settings/view_profile_screen.dart';
import 'package:science/screens/home/user/upload_cv_screen.dart';
import 'package:science/screens/home/user/veiw_job_screen.dart';
import 'package:science/server/user/user.dart';
import 'package:science/shared/color.dart';
import 'package:science/widgets/custom_list_tile.dart';
import 'package:science/widgets/custom_text_form_field.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeUserScreen extends StatefulWidget {
  const HomeUserScreen({Key? key}) : super(key: key);

  @override
  State<HomeUserScreen> createState() => _HomeUserScreenState();
}

class _HomeUserScreenState extends State<HomeUserScreen> {
  final CarouselController _controller = CarouselController();
  int _current = 0;
  var data2;
  int data3Length = 0;
  bool isDone = false;
  bool isOpen = false;
  String filter = "";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        data2 = value.data();
      });
    }).whenComplete(() {
      setState(() {
        isDone = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isDone
        ? WillPopScope(
            onWillPop: () async {
              SystemNavigator.pop();

              return await true;
            },
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: const Text(
                  "Science Jobs",
                  style: TextStyle(fontSize: 20),
                ),
                iconTheme: IconThemeData(
                    color: Theme.of(context).textTheme.bodyText1!.color),
                actions: [
                  PopupMenuTheme(
                    data: PopupMenuThemeData(
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                    child: PopupMenuButton(
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: 1,
                            onTap: () {
                              setState(() {
                                filter = "";
                              });
                            },
                            child: Text(
                              "All",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 2,
                            onTap: () {
                              setState(() {
                                filter = "Full-Time";
                              });
                            },
                            child: Text(
                              "Full-Time",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 3,
                            onTap: () {
                              setState(() {
                                filter = "Part-Time";
                              });
                            },
                            child: Text(
                              "Part-Time",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color,
                              ),
                            ),
                          ),
                        ];
                      },
                      icon: Icon(Icons.filter_list),
                    ),
                  ),
                ],
              ),
              drawer: Drawer(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                child: ListView(
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(
                              data2["image"],
                            ),
                          ),
                          borderRadius: BorderRadius.circular(size.width * 0.3),
                        ),
                        child: SizedBox(
                          height: size.width * 0.3,
                          width: size.width * 0.3,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.02,
                    ),
                    Center(
                      child: Text(
                        data2["username"],
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Center(
                      child: Text(
                        data2["email"],
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.01,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ViewProfileScreen(data: data2)));
                        },
                        child: Text(
                          "View Profile",
                          style: TextStyle(
                            color: colorButton,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    CustomListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ApplicationsScreen(data: data2)));
                      },
                      text: "Applications",
                      iconData: Icons.live_help_outlined,
                    ),
                    CustomListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SavedScreen()));
                      },
                      text: "Saved",
                      iconData: Icons.bookmark,
                    ),
                    ListTile(
                      onTap: () {
                        setState(() {
                          isOpen = !isOpen;
                        });
                      },
                      title: Text(
                        "CV",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color,
                          fontSize: 16,
                        ),
                      ),
                      leading: Icon(
                        Icons.calendar_today,
                        color: Theme.of(context).iconTheme.color,
                      ),
                      trailing: Icon(
                        isOpen
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    isOpen
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              children: [
                                CustomListTile(
                                  onTap: () async {
                                    await launch("https://novoresume.com/");
                                  },
                                  text: "Create your pro CV",
                                  iconData: Icons.create,
                                ),
                                CustomListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const UploadCvScreen()));
                                  },
                                  text: "Upload your pro CV",
                                  iconData: Icons.upload,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    CustomListTile(
                      onTap: () async {
                        await launch(
                            "https://drive.google.com/drive/folders/1-RcGrdf7F5-SYLovm6Yj-aDF76xsMfbb?usp=sharing");
                      },
                      text: "Online Sessions",
                      iconData: Icons.work_outline_sharp,
                    ),
                    CustomListTile(
                      onTap: () async {
                        await launch(
                            "https://drive.google.com/drive/folders/1VOxtZnSG06lstjP7wi0qdzldSt_OZ1A_?usp=sharing");
                      },
                      text: "Tracks Leads to jobs",
                      iconData: Icons.list_alt,
                    ),
                    CustomListTile(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SettingScreen(userId: data2["uid"])));
                      },
                      text: "Settings",
                      iconData: Icons.settings,
                    ),
                    ListTile(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                title: Column(
                                  children: [
                                    const Icon(
                                      Icons.exit_to_app,
                                      color: Colors.red,
                                    ),
                                    SizedBox(
                                      height: size.height * 0.05,
                                    ),
                                    Text(
                                      "Logout from your account",
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color,
                                      ),
                                    ),
                                  ],
                                ),
                                actions: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Center(
                                        child: TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: TextButton(
                                          onPressed: () {
                                            FirebaseAuth.instance.signOut();
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                            "Logout",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              );
                            });
                      },
                      title: const Text(
                        "Logout",
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                      leading: const Icon(
                        Icons.exit_to_app,
                        color: Colors.red,
                      ),
                    )
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(right: 10, left: 10),
                child: ListView(
                  children: [
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    StreamBuilder<DocumentSnapshot>(
                        stream: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data!;
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: size.width * 0.18,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Welcome Back!",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        "${data["username"]} 👋",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color,
                                          fontSize: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ViewProfileScreen(data: data)));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        image: DecorationImage(
                                            image: NetworkImage(data["image"]),
                                            fit: BoxFit.cover)),
                                    height: size.width * 0.18,
                                    width: size.width * 0.18,
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return SizedBox(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: colorButton,
                                ),
                              ),
                            );
                          }
                        }),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Feature Jobs",
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1!.color,
                              fontSize: 20),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const FeatureJobsScreen()));
                            },
                            child: const Text(
                              "See all",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                            )),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: filter == ""
                            ? getFeatureJobs()
                            : getFeatureJobsByFilter(filter),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data!.docs;
                            return Column(
                              children: [
                                CarouselSlider.builder(
                                  itemCount: data.length,
                                  itemBuilder: (BuildContext context,
                                          int itemIndex, int pageViewIndex) =>
                                      SizedBox(
                                          child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    color: Colors.purple,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DetailsScreen(
                                                      data: data[itemIndex],
                                                    )));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              data[itemIndex]
                                                                  ["logo"]),
                                                          fit: BoxFit.cover)),
                                                  height: size.width * 0.15,
                                                  width: size.width * 0.15,
                                                ),
                                                SizedBox(
                                                  width: size.width * 0.35,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10, top: 10),
                                                    child: Text(
                                                      data[itemIndex]["title"],
                                                      style: const TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 17),
                                                      maxLines: 2,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10),
                                                  child: SizedBox(
                                                    height: 50,
                                                    width: 50,
                                                    child: StreamBuilder<
                                                            DocumentSnapshot>(
                                                        stream: getData(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            var data5 =
                                                                snapshot.data!;
                                                            List<dynamic>
                                                                saved =
                                                                data5["saved"];
                                                            return IconButton(
                                                              onPressed: () {
                                                                if (saved.contains(
                                                                    data[itemIndex]
                                                                        .id)) {
                                                                  saved.remove(
                                                                      data[itemIndex]
                                                                          .id);
                                                                  removeSave(
                                                                    id: data[
                                                                            itemIndex]
                                                                        .id,
                                                                    saved:
                                                                        saved,
                                                                  );
                                                                  setState(
                                                                      () {});
                                                                } else {
                                                                  saved.add(
                                                                      data[itemIndex]
                                                                          .id);
                                                                  addSave(
                                                                      saved:
                                                                          saved);
                                                                  setState(
                                                                      () {});
                                                                }
                                                              },
                                                              icon: Icon(
                                                                saved.contains(
                                                                        data[itemIndex]
                                                                            .id)
                                                                    ? Icons
                                                                        .bookmark
                                                                    : Icons
                                                                        .bookmark_add,
                                                                color: saved.contains(
                                                                        data[itemIndex]
                                                                            .id)
                                                                    ? Colors
                                                                        .blue
                                                                    : Colors
                                                                        .grey,
                                                              ),
                                                            );
                                                          } else {
                                                            return SizedBox(
                                                              child: Center(
                                                                child:
                                                                    CircularProgressIndicator(
                                                                  color:
                                                                      colorButton,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                        }),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Text(
                                                      data[itemIndex]
                                                          ["job_type"],
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Text(
                                                      data[itemIndex]["time"],
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.3),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            25),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: Text(
                                                      data[itemIndex]
                                                          ["expertise"],
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                      maxLines: 1,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\$${data[itemIndex]["salary"]}/${data[itemIndex]["salary_refund"]}",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                                Text(
                                                  data[itemIndex]["address"],
                                                  maxLines: 1,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                                  carouselController: _controller,
                                  options: CarouselOptions(
                                      height: size.height * 0.3,
                                      aspectRatio: 16 / 9,
                                      viewportFraction: 0.8,
                                      initialPage: 0,
                                      enableInfiniteScroll: true,
                                      reverse: false,
                                      autoPlay: true,
                                      autoPlayInterval:
                                          const Duration(seconds: 3),
                                      autoPlayAnimationDuration:
                                          const Duration(milliseconds: 800),
                                      autoPlayCurve: Curves.fastOutSlowIn,
                                      enlargeCenterPage: true,
                                      scrollDirection: Axis.horizontal,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _current = index;
                                        });
                                      }),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: data.asMap().entries.map((entry) {
                                    return GestureDetector(
                                      onTap: () =>
                                          _controller.animateToPage(entry.key),
                                      child: Container(
                                        width:
                                            _current == entry.key ? 20 : 12.0,
                                        height: 12.0,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 4.0),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: _current == entry.key
                                                ? colorButton
                                                : Colors.grey),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            );
                          } else {
                            return SizedBox(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: colorButton,
                                ),
                              ),
                            );
                          }
                        }),
                    StreamBuilder<QuerySnapshot>(
                        stream: getJobType(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var data = snapshot.data!.docs;
                            return ListView.builder(
                                itemCount: data.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return ListView(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data[index]["name"],
                                            maxLines: 1,
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color,
                                              fontSize: 20,
                                            ),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            ViewJobScreen(
                                                                job_type: data[
                                                                        index]
                                                                    ["name"])));
                                              },
                                              child: const Text(
                                                "See all",
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18,
                                                ),
                                              )),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * 0.03,
                                      ),
                                      StreamBuilder<QuerySnapshot>(
                                          stream: filter == ""
                                              ? getJobOfType(
                                                  data[index]["name"])
                                              : getJobOfTypeByFilter(
                                                  data[index]["name"], filter),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData) {
                                              var data3 = snapshot.data!.docs;
                                              data3Length = data3.length;
                                              return data3Length == 0
                                                  ? const SizedBox()
                                                  : SizedBox(
                                                      height: size.height * 0.3,
                                                      child: ListView.builder(
                                                          itemCount:
                                                              data3.length,
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          shrinkWrap: true,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return SizedBox(
                                                              width:
                                                                  size.width *
                                                                      0.4,
                                                              child: Card(
                                                                elevation: 6,
                                                                color: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) => DetailsScreen(
                                                                                  data: data3[index],
                                                                                )));
                                                                  },
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        height: size.height *
                                                                            0.15,
                                                                        width: size.width *
                                                                            0.4,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10),
                                                                          image: DecorationImage(
                                                                              image: NetworkImage(data3[index]["logo"]),
                                                                              fit: BoxFit.fill),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        height: size.height *
                                                                            0.01,
                                                                      ),
                                                                      Text(
                                                                        data3[index]
                                                                            [
                                                                            "title"],
                                                                        style:
                                                                            TextStyle(
                                                                          color: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1!
                                                                              .color,
                                                                          fontSize:
                                                                              18,
                                                                        ),
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                      SizedBox(
                                                                        height: size.height *
                                                                            0.01,
                                                                      ),
                                                                      Text(
                                                                        "\$${data3[index]["salary"]}/${data3[index]["salary_refund"]}",
                                                                        style:
                                                                            TextStyle(
                                                                          color: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1!
                                                                              .color,
                                                                        ),
                                                                        maxLines:
                                                                            1,
                                                                      ),
                                                                      SizedBox(
                                                                        height: size.height *
                                                                            0.01,
                                                                      ),
                                                                      Text(
                                                                        data3[index]
                                                                            [
                                                                            "address"],
                                                                        maxLines:
                                                                            1,
                                                                        style:
                                                                            const TextStyle(
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            );
                                                          }),
                                                    );
                                            } else {
                                              return SizedBox(
                                                child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: colorButton,
                                                  ),
                                                ),
                                              );
                                            }
                                          })
                                    ],
                                  );
                                });
                          } else {
                            return SizedBox(
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: colorButton,
                                ),
                              ),
                            );
                          }
                        }),
                  ],
                ),
              ),
            ),
          )
        : Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: colorButton,
              ),
            ),
          );
  }
}
