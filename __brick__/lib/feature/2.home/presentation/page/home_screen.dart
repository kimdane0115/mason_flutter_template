import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/constants/index.dart';
import '../../../1.auth/presentation/provider/supabase_auth_provider.async_notifier.dart';

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
        body: home(),
      ),
    );
  }

  Widget home() {
    return Column(
      children: [
        // ElevatedButton(
        //   onPressed: () {
        //     // googlelogin();
        //     ref.watch(authAsyncNotifierProvider.notifier).signInWithGoogle();
        //   },
        //   child: const Text('Login Button'),
        // ),
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