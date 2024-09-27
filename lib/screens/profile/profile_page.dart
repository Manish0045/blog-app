part of 'profile_page_imports.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final dbRef = FirebaseDatabase.instance.ref().child('Posts');
  final auth = FirebaseAuth.instance;
  late String userId;
  int totalPosts = 0;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    userId = auth.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      await _getTotalPosts();
    }
  }

  Future<void> _getTotalPosts() async {
    try {
      final postsSnapshot = await dbRef
          .child("Post List")
          .orderByChild('uUid')
          .equalTo(userId)
          .once();
      final posts = postsSnapshot.snapshot.children.toList();
      setState(() {
        totalPosts = posts.length;
      });
    } catch (e) {
      // Handle any errors
      print('Error fetching posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                          top: 100, left: 30.0, right: 30.0),
                      height: 200,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.cyan,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(60.0)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.blue,
                            child: Icon(
                              Icons.person,
                              size: 25,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Text(
                            'Total Posts: $totalPosts',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: FirebaseAnimatedList(
                        query: dbRef
                            .child("Post List")
                            .orderByChild('uUid')
                            .equalTo(userId),
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          Map<dynamic, dynamic> postData =
                              snapshot.value as Map<dynamic, dynamic>;
                          return buildPostCard(postData);
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
                  height: 100.0,
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
                        "Profile",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: ConstantColors.bgColor,
                        ),
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
