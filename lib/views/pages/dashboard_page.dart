import 'package:attappv1/data/constants.dart';
import 'package:attappv1/views/pages/login_page.dart';
import 'package:attappv1/views/widgets/class_card.dart';
import 'package:flutter/material.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          IconButton(onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
              return LoginPage();
            },));
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your classes', style: TextStyle(fontSize: 18),),
            SizedBox(height: 20,),
            Column(
              children: Constants.assignedClasses.map((e){
                return ClassCard(assignedClass: e);
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}