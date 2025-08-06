import 'dart:ffi';

import 'package:algebraic/models/modules_list_model.dart';
import 'package:algebraic/services/api_provider.dart';
import 'package:algebraic/utils/constants.dart';
import 'package:algebraic/utils/streakmanager.dart';
import 'package:algebraic/view/components/textformfield_widget.dart';
import 'package:algebraic/view/login.dart';
import 'package:flutter/material.dart';
import 'package:algebraic/models/user.dart';

import '../../utils/sharedpref.dart';
import 'package:algebraic/routes/route_constants.dart';
import 'package:flutter_svg/svg.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  // Load user data
  bool isloading = true;
  bool isloadingstatistics = true;

  UserDetails? user;
  UserDetails userDetails = UserDetails();

  int numReadLessons = 0;
  int totalLessons = 47; // HARD SET VALUE

  final streakManager = StreakManager();
  int currentStreak = 0;

  List<ModulesList> modulesList = [];

  int totalModules = -1;
  int completedModules = -1;

  double averageQuizScore = -1;
  
  Future<void> getInitialValue() async {
    setState(() {
      isloading = true;
      isloadingstatistics = true;
    });
    SharedPref sharedPref = SharedPref();

    user = UserDetails.fromJson(await sharedPref.read("user"));
    setState(() {
      userDetails = user!;
      isloading = false;
    });

    // Lessons
    List readLessonsList = await sharedPref.read("readList") ?? [];
    setState(() {
      numReadLessons = readLessonsList.length;
    });

    // Streak
    int streak = await streakManager.getCurrentStreak();
    setState(() {
      currentStreak = streak;
    });

    // Prep to calculate average score and modules
    await getModulesList();
    
    // Average quiz score
    int count = 0;

    int numScores = 0;
    int scoreTotal = 0;

    for (ModulesList module in modulesList) {
      if(module.scorePercentage != null) {
        int score = module.scorePercentage;
        
        numScores += 1;
        scoreTotal += score;
      }

      count += 1;
    }

    double averageScore = double.parse((scoreTotal.toDouble()/numScores).toStringAsFixed(1));

    setState(() {
      averageQuizScore = averageScore;
    });

    // Modules
    setState(() {
      completedModules = numScores;
      totalModules = count;
    });
  }

  Future<void> getModulesList() async {
    setState(() {
      isloadingstatistics = true;
    });
    GetModulesApiProvider modulesListApi = GetModulesApiProvider();
    try {
      await modulesListApi.getModulesAPI(userDetails.id).then((op) => {
            setState(() {
              if (op["data"] != null) {
                final List resItems = op["data"];
                modulesList = resItems
                    .map((resRaw) => ModulesList.fromJson(resRaw))
                    .toList();
              }
            }),
            setState(() {
              isloadingstatistics = false;
            })
          });
    } catch (e) {
      setState(() {
        isloadingstatistics = false;
      });
    }
  }

  @override
  void initState() {
    getInitialValue();
    super.initState();
  }

  // Create app bar
  AppBar appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: themeColor,
      
      leading: null,
      title: Row(
        children: [
          Text(
            'Profile',
            style: TextStyle(
                fontSize: 15.75,
                fontWeight: FontWeight.w500,
                color: Colors.white),
          ),
        ],
      ),

      centerTitle: false,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 18.0),
          child: CircleAvatar(
            radius: 14,
            backgroundColor: activeColorGreen,
            child: Text(
              userDetails.firstName![0].toUpperCase(),
              style: TextStyle(
                  fontSize: 13.85,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
          ),
        )
      ],
    );
  }

  SizedBox saveButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9))),
            backgroundColor: activeColorGreen,
            elevation: 0),
        onPressed: () {
          
        },
        child: const Text(
          'Save',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 14, color: Colors.white),
        ),
      ),
    );
  }

  SizedBox logoutButton() {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(9)),
              side: BorderSide(
                color: Colors.red,
                width: 1.0,
              )
            ),
            backgroundColor: Colors.transparent,
            elevation: 0).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.red.withAlpha(30);
                }
                return null;
              }),
              shadowColor: WidgetStateProperty.all(Colors.transparent),
            ),
        onPressed: () {onLogout();},
        child: const Text(
          'Logout',
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 14, color: Colors.red),
        ),
      ),
    );
  }

  Future<void> onLogout() async {
    SharedPref sharedPref = SharedPref();
    final navigator = Navigator.of(context, rootNavigator: true);

    await sharedPref.remove("user");
    if (!mounted) return; // <- Prevents calling context if widget is disposed
    navigator.pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: isloading
        ? Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                color: themeColor,
                strokeWidth: 2,
              ),
            ),
          )
        : Scaffold(
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        appBar: appBar(),
        body: Container(
          color: Color.fromRGBO(250, 250, 250, 1),
          
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 19),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    profileImage(context),

                    isloadingstatistics ? SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: themeColor,
                          strokeWidth: 2,
                        ),
                      ),
                    ) : SizedBox(
                      height: 200,
                      child: infoGrid(context)
                    ),

                    // Heading text
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        'Account Settings',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color.fromRGBO(34, 34, 34, 1)),
                      ),
                    ),

                    // Editable fields
                    const Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child: TextformWidget(
                        obscureText: true,
                        maxlines: 1,
                        initialValue: '', labelName: 'Password',
                        // saved: (val) => eventName = val,
                        // focusNode: nameFieldFocus,
                        autofocus: false,
                        isMandatory: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        capitalization: TextCapitalization.words,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child: TextformWidget(
                        obscureText: true,
                        maxlines: 1,
                        initialValue: '', labelName: 'Retype Password',
                        // saved: (val) => eventName = val,
                        // focusNode: nameFieldFocus,
                        autofocus: false,
                        isMandatory: true,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        capitalization: TextCapitalization.words,
                      ),
                    ),

                    // Save button
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: saveButton()),
                        ),
                      ],
                    ),

                    // Logout button
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: logoutButton()),
                        ),
                      ],
                    ),

                    /*
                    OLD Logout button
                    InkWell(
                      onTap: () {
                        onLogout();
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(right: 30.0, top: 30),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: const Color.fromRGBO(243, 244, 248, 1),
                            child: SvgPicture.asset(CustomIcons.logout),
                          )),
                    ),
                    */

                  ]),
            )),
          ),
        ),
      ),
    );
  }

  // Top section with profile image
  Padding profileImage(context){
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsetsGeometry.only(bottom: 16),

      child: Align(
        alignment: Alignment.center,

        child: Column(
          children: [

            // Profile logo
            CircleAvatar(
              radius: 45,
              backgroundColor: activeColorGreen,
              child: Text(
                userDetails.firstName![0].toUpperCase(),
                style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),

            // User name
            Padding(
              padding: EdgeInsetsGeometry.only(top: 8),

              child: Text(
                '${userDetails.firstName!} ${userDetails.lastName!}',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.primary),
              ),
            ),
          ], 
        ),
      )
    );
  }

  // 4x4 grid with user stats
  Padding infoGrid(context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsetsGeometry.only(top: 16),

      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 4,
          childAspectRatio: (2 / 1),
        ),
        itemCount: 4,

        itemBuilder: (context, index) {
          if(index == 0) {
            return modulesTile(context);
          } else if (index == 1) {
            return lessonsTile(context);
          } else if (index == 2) {
            return avgQuizScoreTile(context);
          } else {
            return streakTile(context);
          }
        },
      ),
    );
  }

  // Grid tiles
  Container modulesTile(context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(9)
      ),

      child: Padding(
        padding: EdgeInsetsGeometry.all(10),

        child: Row(
          children: [
            // Icon
            LayoutBuilder(
              builder: (context, constraints) {
                final max_height = constraints.maxHeight * 0.9;
                return Container(
                  height: max_height,

                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: activeColorGreen.withAlpha(75),
                        borderRadius: BorderRadius.circular(9)
                      ),
                    
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(12),

                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.view_list,
                            color: activeColorGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Text
            Padding(
              padding: EdgeInsetsGeometry.only(left: 12, top: 4),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text(
                    'Modules',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary),
                  ),

                  // Statistic
                  Text(
                    totalModules == -1 ? '---' : '${completedModules}/${totalModules}',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Container lessonsTile(context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(9)
      ),

      child: Padding(
        padding: EdgeInsetsGeometry.all(10),

        child: Row(
          children: [
            // Icon
            LayoutBuilder(
              builder: (context, constraints) {
                final max_height = constraints.maxHeight * 0.9;
                return Container(
                  height: max_height,

                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: activeColorGreen.withAlpha(75),
                        borderRadius: BorderRadius.circular(9)
                      ),
                    
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(12),

                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.menu_book_rounded,
                            color: activeColorGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Text
            Padding(
              padding: EdgeInsetsGeometry.only(left: 12, top: 4),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text(
                    'Lessons',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary),
                  ),

                  // Statistic
                  Text(
                    '${numReadLessons}/${totalLessons}',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Container avgQuizScoreTile(context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(9)
      ),

      child: Padding(
        padding: EdgeInsetsGeometry.all(10),

        child: Row(
          children: [
            // Icon
            LayoutBuilder(
              builder: (context, constraints) {
                final max_height = constraints.maxHeight * 0.9;
                return Container(
                  height: max_height,

                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: activeColorGreen.withAlpha(75),
                        borderRadius: BorderRadius.circular(9)
                      ),
                    
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(12),

                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.emoji_events_rounded,
                            color: activeColorGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Text
            Padding(
              padding: EdgeInsetsGeometry.only(left: 12, top: 4),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text(
                    'Average',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary),
                  ),

                  // Statistic
                  Text(
                    averageQuizScore == -1 ? "---" : '${averageQuizScore}%',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  Container streakTile(Context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(255, 255, 255, 1),
        borderRadius: BorderRadius.circular(9)
      ),

      child: Padding(
        padding: EdgeInsetsGeometry.all(10),

        child: Row(
          children: [
            // Icon
            LayoutBuilder(
              builder: (context, constraints) {
                final max_height = constraints.maxHeight * 0.9;
                return Container(
                  height: max_height,

                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: activeColorGreen.withAlpha(75),
                        borderRadius: BorderRadius.circular(9)
                      ),
                    
                      child: Padding(
                        padding: EdgeInsetsGeometry.all(12),

                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Icon(
                            Icons.local_fire_department,
                            color: activeColorGreen,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Text
            Padding(
              padding: EdgeInsetsGeometry.only(left: 12, top: 4),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label
                  Text(
                    'Streak',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.secondary),
                  ),

                  // Statistic
                  Text(
                    '${currentStreak} days',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary),
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
