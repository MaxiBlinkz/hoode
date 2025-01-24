import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// Theme constants (add these to a theme file if you haven't already)
const Color primaryBlue = Color(0xFF3A86FF);
const Color accentOrange = Color(0xFFFFB703);
const Color lightGray = Color(0xFFF5F5F5);
const Color darkGray = Color(0xFF333333);
const Color lightGreen = Color(0xFF00FF00);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Real Estate App',
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: primaryBlue,
          scaffoldBackgroundColor: lightGray,
          appBarTheme: const AppBarTheme(
            backgroundColor: lightGray,
            elevation: 0,
            titleTextStyle: TextStyle(
              color: darkGray,
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
            ),
            iconTheme: IconThemeData(color: darkGray),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: primaryBlue, brightness: Brightness.light),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: darkGray),
            bodyMedium: TextStyle(color: darkGray),
            bodySmall: TextStyle(color: darkGray),
            titleLarge: TextStyle(color: darkGray, fontWeight: FontWeight.bold),
            titleMedium: TextStyle(color: darkGray, fontWeight: FontWeight.bold),
            titleSmall: TextStyle(color: darkGray, fontWeight: FontWeight.bold),

          ),
          iconTheme: const IconThemeData(color: primaryBlue),
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                foregroundColor: primaryBlue
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: primaryBlue
              )
          ),
          checkboxTheme: CheckboxThemeData(
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return primaryBlue;
                }
                return Colors.grey;
              }),
              checkColor: MaterialStateProperty.all(Colors.white)
          )
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected tab
  final List<String> _filterOptions = ['All','House','Apartment','Villa','Pent'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
        actions: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.tune))
        ],
        bottom:  PreferredSize(
        preferredSize: const Size.fromHeight(60),
          child:  Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child:  const Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 10.0),
                    child:  TextField(
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                        hintText: "Search by location, property type...",
                          border: InputBorder.none
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: _filterOptions.map((option) =>
                      FilterButton(text: option, isSelected: _filterOptions.indexOf(option) == 0 , onTap: () {},)
                    ).toList()
                  ),
                )
              ],
            ),
          )
        )
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionHeader('Featured Properties', 'See All'),
            SizedBox(
              height: 310,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _buildPropertyCard(
                    'assets/house1.jpg',
                    '\$ 850,000',
                    'Beverly Hills, CA',
                    '4 beds',
                    '3 baths',
                      '2800 sqft',
                    'Sarah Johnson',
                    true,
                      context: context
                  ),
                  _buildPropertyCard(
                    'assets/house2.jpg',
                    '\$ 1,200,000',
                    'Miami, FL',
                    '3 beds',
                    '2 baths',
                      '3000 sqft',
                    'Michael Brown',
                    true,
                      context: context
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade300,
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("View on Map", style: Theme.of(context).textTheme.bodyMedium),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            _buildSectionHeader('Latest Properties', 'See All'),
            SizedBox(
              height: 310,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  _buildPropertyCard(
                      'assets/house3.jpg',
                      '\$ 495,000',
                      'Seattle, WA',
                      '2 beds',
                      '2 baths',
                      '1500 sqft',
                      'Emily Davis',
                      false,
                      isNew: true,
                    context: context
                  ),
                  _buildPropertyCard(
                    'assets/house4.jpg',
                      '\$ 675,000',
                      'Austin, TX',
                    '4 beds',
                    '3 baths',
                      '2600 sqft',
                    'David Wilson',
                    false,
                    isPriceReduced: true,
                      context: context
                  ),
                ],
              ),
            ),
            const SizedBox(height: 100) // Add spacing for the bottom navigation bar
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed, // Keep the labels visible
      ),
    );
  }

  Widget _buildSectionHeader(String title, String buttonText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          TextButton(onPressed: () {}, child: Text(buttonText)),
        ],
      ),
    );
  }


  Widget _buildPropertyCard(String imagePath, String price, String location, String beds, String baths,String sqft,String agentName, bool isFeatured, {bool isNew=false, bool isPriceReduced=false, required BuildContext context}) {
    return Container(
      width: 260,
      margin: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                    image: DecorationImage(
                        image: AssetImage(imagePath),
                        fit: BoxFit.cover
                    )
                  ),
                ),
                if(isFeatured) Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.blue
                    ),
                    child: Text("Featured", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),),
                  ),
                ),
                if(isNew) Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.green
                    ),
                    child: Text("New", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),),
                  ),
                ),
                if(isPriceReduced) Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: accentOrange
                    ),
                    child: Text("Price Reduced", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white),),
                  ),
                ),
                Positioned(
                    top: 10,
                    right: 10,
                    child: const Icon(Icons.favorite_border, color: Colors.white)
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(price, style:  Theme.of(context).textTheme.titleSmall),
                  Text(location, style: Theme.of(context).textTheme.bodyMedium),
                  Row(
                    children: [
                      const Icon(Icons.bed, size: 14, color: Colors.grey),
                      Text(beds, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 8,),
                      const Icon(Icons.bathtub, size: 14, color: Colors.grey),
                      Text(baths, style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(width: 8,),
                       Icon(Icons.crop_square_outlined, size: 14, color: Colors.grey),
                        Text(sqft, style: Theme.of(context).textTheme.bodySmall)
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: AssetImage("assets/person.jpg"),
                      ),
                      const SizedBox(width: 5),
                      Text(agentName, style: Theme.of(context).textTheme.bodyMedium),
                      const Icon(Icons.verified, color: primaryBlue, size: 14,)
                    ],
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;
  const FilterButton({super.key, required this.text, this.isSelected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isSelected? primaryBlue : Colors.grey.shade200,
        ),
        child: Text(text, style: TextStyle(color: isSelected? Colors.white: darkGray)),
      ),
    );
  }
}