import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/constants/index.dart';
import '../../../1.auth/presentation/provider/supabase_auth_provider.async_notifier.dart';
import '../provider/home_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('팀명'),
          actions: [
            IconButton(
              onPressed: () {
              },
              icon: const Icon(
                Icons.more_vert,
              ),
            ),
          ],
        ),
        // body: home(),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: body(context),
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 150,
      child: TableCalendar(
          headerVisible: false,
          // daysOfWeekHeight: 2,
          daysOfWeekStyle: const DaysOfWeekStyle(
            weekdayStyle: TextStyle(
              fontSize: 8,
            ),
            weekendStyle: TextStyle(fontSize: 8)),
        calendarStyle: const CalendarStyle(
            weekendTextStyle: TextStyle(fontSize: 8),
            weekNumberTextStyle: TextStyle(fontSize: 8),
            outsideTextStyle: TextStyle(fontSize: 8),
            defaultTextStyle: TextStyle(fontSize: 8),
            disabledTextStyle: TextStyle(fontSize: 8)
            ),
          shouldFillViewport: true,
          firstDay: DateTime(2020),
          lastDay: DateTime(2021),
          focusedDay: DateTime(2020),
          ),
    );
  }

  Widget home() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: () {
            // googlelogin();
            ref.watch(supaBaseAuthAsyncNotifierProvider.notifier).signOut();
          },
          child: const Text('LogOut'),
        ),
        ElevatedButton(
          onPressed: () {
            // googlelogin();
            getFcmToken();
          },
          child: const Text('getFcm Token'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(getMembersProvider).call('');
          },
          child: const Text('Get Memeber'),
        ),
        ElevatedButton(
          onPressed: () {
            final request = {
              'name': '호날두',
              'fcm_token': '123456',
              'profile_image_url': '1234567',
              'created_at': DateTime.now().toIso8601String(),
            };
            ref.read(addMemberProvider).call(request);
          },
          child: const Text('Add Memeber'),
        ),
        ElevatedButton(
          onPressed: () {
            final request = {
              // 'name': '메시',
              'fcm_token': 'adkfkj',
              'profile_image_url': 'https://www.ddd.com',
              'updated_at': DateTime.now().toIso8601String(),
            };
            // final request = {
            //   'region' : '111111'
            // };
            ref.read(updateMemeberProvider).call(request, 4);
          },
          child: const Text('Update Memeber'),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(deleteMemeberProvider).call(7);
          },
          child: const Text('Deleted Memeber'),
        ),
      ],
    );
  }
  Future<void> getFcmToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    print('>>>> fcmToken : $token');
  }

    Future<void> googlelogin() async {
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      print('>>>> displayName : ${googleUser?.displayName}');
      print('>>>> email : ${googleUser?.email}');
      print('>>>> accessToken : ${googleAuth?.accessToken}');
      print('>>>> idToken : ${googleAuth?.idToken}');

       OAuthCredential _googleCredential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );

      UserCredential _credential =
          await FirebaseAuth.instance.signInWithCredential(_googleCredential);
      if (_credential.user != null) {
        print(">>>> ${_credential.user}");
      }

      // Create a new credential
      // final credential = GoogleAuthProvider.credential(
      //   accessToken: googleAuth?.accessToken,
      //   idToken: googleAuth?.idToken,
      // );
  }
}