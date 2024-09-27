part of 'add_blog_screen_imports.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({super.key});

  @override
  State<AddBlog> createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  bool showSpinner = false;
  final DatabaseReference postRef =
      FirebaseDatabase.instance.ref().child('Posts');
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  File? _image;
  final picker = ImagePicker();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  void dialogueBox(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          content: SizedBox(
            height: 120.0,
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    getImageFromCamera();
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                  ),
                ),
                InkWell(
                  onTap: () {
                    getImageFromGallery();
                    Navigator.pop(context);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text("Gallery"),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        toastMessage("No Image selected!");
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        toastMessage("No Image selected!");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        backgroundColor: ConstantColors.bgColor,
        appBar: AppBar(
          title: const Text("Add a Blog"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                InkWell(
                  onTap: () {
                    dialogueBox(context);
                  },
                  child: Center(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * 1,
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _image!,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.shade100,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: const Icon(
                                Icons.camera,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: titleController,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: "Title",
                          hintText: "Enter post title",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      TextFormField(
                        controller: descriptionController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: "Description",
                          hintText: "Enter post description",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      RoundedButton(
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            if (_image == null) {
                              throw Exception("Please select an image");
                            }

                            int date = DateTime.now().microsecondsSinceEpoch;
                            firebase_storage.Reference ref = firebase_storage
                                .FirebaseStorage.instance
                                .ref()
                                .child('blogapp$date.jpg');
                            firebase_storage.UploadTask uploadTask =
                                ref.putFile(_image!);
                            await uploadTask.whenComplete(() async {
                              if (uploadTask.snapshot.state ==
                                  firebase_storage.TaskState.success) {
                                var downloadUrl = await ref.getDownloadURL();
                                final User? user = _auth.currentUser;
                                await postRef
                                    .child('Post List')
                                    .child(date.toString())
                                    .set({
                                  'pId': date.toString(),
                                  'pImage': downloadUrl.toString(),
                                  'pTime': date.toString(),
                                  'pTitle': titleController.text,
                                  'pDescription': descriptionController.text,
                                  'uEmail': user!.email!,
                                  'uUid': user.uid,
                                });

                                setState(() {
                                  showSpinner = false;
                                });
                                toastMessage("Published..");
                                Navigator.pop(context);
                              } else {
                                throw Exception("Upload failed");
                              }
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            toastMessage("Failed to publish: $e");
                          }
                        },
                        buttonText: "Upload",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
