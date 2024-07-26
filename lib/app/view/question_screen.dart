// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void addQuestionsToFirestore() async {
//   final questions = [
//     {
//       'kidQuestion': 'What is your favorite lunch meal?',
//       'parentQuestion': 'What is your kid\'s favorite lunch meal?',
//       'options': ['Pizza', 'Burger', 'Sandwich', 'Salad'],
//     },
//     {
//       'kidQuestion': 'What is your favorite subject?',
//       'parentQuestion': 'What is your kid\'s favorite subject?',
//       'options': ['Math', 'Science', 'English', 'History'],
//     },
//     {
//       'kidQuestion': 'What is your favorite drink to have with lunch?',
//       'parentQuestion': 'What is your kid\'s favorite drink to have with lunch?',
//       'options': ['Water', 'Juice', 'Milk', 'Soda'],
//     },
//     {
//       'kidQuestion': 'What is your favorite school activity?',
//       'parentQuestion': 'What is your kid\'s favorite school activity?',
//       'options': ['Sports', 'Reading', 'Art', 'Music'],
//     },
//     {
//       'kidQuestion': 'What is your favorite school supply?',
//       'parentQuestion': 'What is your kid\'s favorite school supply?',
//       'options': ['Pencil', 'Notebook', 'Eraser', 'Crayons'],
//     },
//     {
//       'kidQuestion': 'What is your favorite thing to do at recess?',
//       'parentQuestion': 'What is your kid\'s favorite thing to do at recess?',
//       'options': ['Play tag', 'Swing', 'Slide', 'Play ball'],
//     },
//     {
//       'kidQuestion': 'What is your favorite fruit to have in your lunch?',
//       'parentQuestion': 'What is your kid\'s favorite fruit to have in their lunch?',
//       'options': ['Apple', 'Banana', 'Orange', 'Grapes'],
//     },
//     {
//       'kidQuestion': 'What is your favorite snack?',
//       'parentQuestion': 'What is your kid\'s favorite snack?',
//       'options': ['Chips', 'Cookies', 'Granola bar', 'Yogurt'],
//     },
//     {
//       'kidQuestion': 'What is your favorite dessert?',
//       'parentQuestion': 'What is your kid\'s favorite dessert?',
//       'options': ['Ice cream', 'Cake', 'Cookies', 'Brownies'],
//     },
//     {
//       'kidQuestion': 'What is your favorite sport?',
//       'parentQuestion': 'What is your kid\'s favorite sport?',
//       'options': ['Soccer', 'Basketball', 'Baseball', 'Swimming'],
//     },
//     {
//       'kidQuestion': 'What is your favorite animal?',
//       'parentQuestion': 'What is your kid\'s favorite animal?',
//       'options': ['Dog', 'Cat', 'Elephant', 'Lion'],
//     },
//     {
//       'kidQuestion': 'What is your favorite movie?',
//       'parentQuestion': 'What is your kid\'s favorite movie?',
//       'options': ['Toy Story', 'Frozen', 'Lion King', 'Finding Nemo'],
//     },
//     {
//       'kidQuestion': 'What is your favorite TV show?',
//       'parentQuestion': 'What is your kid\'s favorite TV show?',
//       'options': ['SpongeBob', 'Paw Patrol', 'Peppa Pig', 'Mickey Mouse Clubhouse'],
//     },
//     {
//       'kidQuestion': 'What is your favorite book?',
//       'parentQuestion': 'What is your kid\'s favorite book?',
//       'options': ['Harry Potter', 'Diary of a Wimpy Kid', 'Dr. Seuss', 'Magic Tree House'],
//     },
//     {
//       'kidQuestion': 'What is your favorite game?',
//       'parentQuestion': 'What is your kid\'s favorite game?',
//       'options': ['Minecraft', 'Fortnite', 'Roblox', 'Among Us'],
//     },
//     {
//       'kidQuestion': 'What is your favorite color?',
//       'parentQuestion': 'What is your kid\'s favorite color?',
//       'options': ['Red', 'Blue', 'Green', 'Yellow'],
//     },
//     {
//       'kidQuestion': 'What is your favorite season?',
//       'parentQuestion': 'What is your kid\'s favorite season?',
//       'options': ['Summer', 'Winter', 'Spring', 'Fall'],
//     },
//     {
//       'kidQuestion': 'What is your favorite holiday?',
//       'parentQuestion': 'What is your kid\'s favorite holiday?',
//       'options': ['Christmas', 'Halloween', 'Easter', 'Thanksgiving'],
//     },
//     {
//       'kidQuestion': 'What is your favorite hobby?',
//       'parentQuestion': 'What is your kid\'s favorite hobby?',
//       'options': ['Drawing', 'Playing sports', 'Reading', 'Playing video games'],
//     },
//     {
//       'kidQuestion': 'What is your favorite ice cream flavor?',
//       'parentQuestion': 'What is your kid\'s favorite ice cream flavor?',
//       'options': ['Chocolate', 'Vanilla', 'Strawberry', 'Mint chocolate chip'],
//     },
//     {
//       'kidQuestion': 'What is your favorite place to visit?',
//       'parentQuestion': 'What is your kid\'s favorite place to visit?',
//       'options': ['Beach', 'Zoo', 'Park', 'Museum'],
//     },
//     {
//       'kidQuestion': 'What is your favorite ride at the amusement park?',
//       'parentQuestion': 'What is your kid\'s favorite ride at the amusement park?',
//       'options': ['Roller coaster', 'Ferris wheel', 'Bumper cars', 'Carousel'],
//     },
//     {
//       'kidQuestion': 'What is your favorite thing to do on the weekend?',
//       'parentQuestion': 'What is your kid\'s favorite thing to do on the weekend?',
//       'options': ['Watch TV', 'Play outside', 'Visit friends', 'Go to the movies'],
//     },
//     {
//       'kidQuestion': 'What is your favorite bedtime story?',
//       'parentQuestion': 'What is your kid\'s favorite bedtime story?',
//       'options': ['Goodnight Moon', 'The Very Hungry Caterpillar', 'Where the Wild Things Are', 'The Cat in the Hat'],
//     },
//     {
//       'kidQuestion': 'What is your favorite breakfast food?',
//       'parentQuestion': 'What is your kid\'s favorite breakfast food?',
//       'options': ['Pancakes', 'Cereal', 'Eggs', 'Toast'],
//     },
//     {
//       'kidQuestion': 'What is your favorite vegetable?',
//       'parentQuestion': 'What is your kid\'s favorite vegetable?',
//       'options': ['Carrots', 'Broccoli', 'Peas', 'Corn'],
//     },
//     {
//       'kidQuestion': 'What is your favorite thing to wear to school?',
//       'parentQuestion': 'What is your kid\'s favorite thing to wear to school?',
//       'options': ['T-shirt', 'Jeans', 'Dress', 'Shorts'],
//     },
//     {
//       'kidQuestion': 'What is your favorite way to get to school?',
//       'parentQuestion': 'What is your kid\'s favorite way to get to school?',
//       'options': ['Bus', 'Walking', 'Car', 'Bike'],
//     },
//     {
//       'kidQuestion': 'What is your favorite school event?',
//       'parentQuestion': 'What is your kid\'s favorite school event?',
//       'options': ['Field trip', 'School play', 'Sports day', 'Science fair'],
//     },
//     {
//       'kidQuestion': 'What is your favorite thing to do after school?',
//       'parentQuestion': 'What is your kid\'s favorite thing to do after school?',
//       'options': ['Play video games', 'Do homework', 'Play outside', 'Watch TV'],
//     },
//   ];

//   DocumentReference sessionRef = FirebaseFirestore.instance.collection('sessions').doc('currentSession');

//   await sessionRef.update({
//     'questions': FieldValue.arrayUnion(questions),
//   });

//   print('Questions added to Firestore');
// }



// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   addQuestionsToFirestore(); // Add questions to Firestore
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Flutter Firestore Example'),
//       ),
//       body: Center(
//         child: Text('Questions have been added to Firestore!'),
//       ),
//     );
//   }
// }
