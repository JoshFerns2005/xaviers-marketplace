import 'package:xaviers_market/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin{
  @override
  void initState(){
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    Future.delayed(const 
    Duration(seconds : 5),(){ 
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StartScreen(),
      ));
  });
}

@override
void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays:SystemUiOverlay.values);
    super.dispose();
  }

@override
Widget build(BuildContext context){
      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration:const 
          BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color.fromARGB(255, 51, 133, 119)],
              begin:Alignment.topCenter,
              end:Alignment.bottomCenter,
              )),
                child:const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag,
                      size:40,
                      color:Colors.white,
                    ),
                    SizedBox(
                      height:20,
                      ),
                      Text(
                        "Xavier's Marketplace",
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color:Colors.white,
                          fontSize:32,
                        ))
                    ],
                )
        )
      );
  }
}