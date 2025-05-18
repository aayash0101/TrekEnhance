import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors:[
                Color(0xffBB1736),
                Color(0xff281537),
              ] )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 60,left: 22),
            child: Text("Hello\nSign In",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 40,
              color: Colors.white,
            ),),
          ),
          Padding(
            padding: const EdgeInsets.only(top:200),
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )
              ),
              child:Padding(
                padding: const EdgeInsets.only(left:18,right: 18),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.check,color: Colors.grey,),
                        label: Text("Username",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red,
                        ),)
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        suffixIcon: Icon(Icons.visibility_off,color: Colors.grey,),
                        label: Text("Password",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.red,
                        ),)
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text("Forgot Password",style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.black,
                      ),),
                    )
                  ],
                ),
              ),
              
            ),
          ),  
        ],
      ),
    );
  }
}