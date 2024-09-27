part of 'homepage_imports.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController searchController = TextEditingController();
  final dbRef = FirebaseDatabase.instance.ref().child('Posts');
  String search = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          splashColor: Colors.deepPurpleAccent,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddBlog(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
        backgroundColor: ConstantColors.bgColor,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/mobile.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                          top: 125, left: 30.0, right: 30.0),
                      height: 200,
                      decoration: const BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(60.0)),
                      ),
                      child: RoundedInput(
                        hintText: "Search...",
                        prefixIcon: const Icon(Icons.search),
                        labelText: null,
                        controller: searchController,
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: FirebaseAnimatedList(
                        query: dbRef.child('Post List'),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          Map<dynamic, dynamic> postData =
                              snapshot.value as Map<dynamic, dynamic>;
                          String tempTitle = postData['pTitle'];
                          if (searchController.text.isEmpty) {
                            return buildPostCard(postData);
                          } else if (tempTitle
                              .toLowerCase()
                              .contains(searchController.text.toLowerCase())) {
                            return buildPostCard(postData);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 120.0,
                  decoration: const BoxDecoration(
                    color: Color(0xfff4f5fa),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(80.0),
                    ),
                  ),
                  padding: const EdgeInsets.only(left: 130.0, right: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "BlogApp",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.bgColor,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.person_2_rounded),
                          ),
                          IconButton(
                            onPressed: () async {
                              await AuthServices().signOut();
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const SignIn(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.logout_outlined),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPostCard(Map<dynamic, dynamic> postData) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(postData['pTime']),
            postData['pImage'] != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: "assets/images/bg.jpg",
                      image: postData['pImage'],
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholderErrorBuilder: (context, error, stackTrace) {
                        return Image.asset("assets/images/bg.jpg",
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover);
                      },
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset("assets/images/bg.jpg",
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover);
                      },
                    ),
                  )
                : Image.asset("assets/images/bg.jpg",
                    height: 150, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(postData['pTitle'] ?? 'No Title',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            Text(postData['pDescription'] ?? 'No Description'),
          ],
        ),
      ),
    );
  }
}
