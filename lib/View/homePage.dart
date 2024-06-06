import 'dart:io';
import 'package:alphabet_scroll_view/alphabet_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mycontacts/Provider/contact_provider.dart';
import 'package:mycontacts/Provider/hide_ContactProvider.dart';
import 'package:mycontacts/Provider/imageProvider.dart';
import 'package:mycontacts/Provider/stepper_provider.dart';
import 'package:mycontacts/Provider/themeProvider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Contacts",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        actions: [
          Switch(
              value: Provider.of<ThemeProvider>(context).appTheme.isDark,
              onChanged: (val) {
                Provider.of<ThemeProvider>(context, listen: false)
                    .changeTheme(val);
              }),
          Checkbox(
            value: true,
            onChanged: (val) {},
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed('search');
            },
            icon: const Icon(Icons.search),
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return <PopupMenuEntry>[
                PopupMenuItem(
                  onTap: () {
                    Future.microtask(() async {
                      final LocalAuthentication auth = LocalAuthentication();
                      bool isAuth = await auth.authenticate(
                          localizedReason:
                              "Please authenticate to show hidden Contacts",
                          options: const AuthenticationOptions());

                      if (isAuth) {
                        Navigator.of(context).pushNamed('hidePage');
                      }
                    });
                  },
                  child: const Text("Hidden Contacts"),
                ),
              ];
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return const AlertBox();
            },
          );
          final stepperProvider =
              Provider.of<StepperProvider>(context, listen: false);
          stepperProvider.nameController.clear();
          stepperProvider.contactController.clear();
          stepperProvider.emailController.clear();
          stepperProvider.step = 0;
        },
        child: const Icon(Icons.add),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, contactProvider, _) {
          return AlphabetScrollView(
            list: contactProvider.allContact
                .map((e) => AlphaModel(e.name))
                .toList(),
            alignment: LetterAlignment.right,
            itemExtent: 100,
            selectedTextStyle: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            unselectedTextStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
            itemBuilder: (context, index, id) {
              final contact = contactProvider.allContact[index];
              return Padding(
                padding: const EdgeInsets.only(left: 12, right: 12, bottom: 1),
                child: Card(
                  elevation: 3,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed('detailPage', arguments: contact);
                    },
                    subtitle: Row(
                      children: [
                        Consumer<imageProvider>(
                          builder: (context, imageProvider, _) {
                            return CircleAvatar(
                              radius: 30,
                              backgroundImage:
                                  imageProvider.pickImagePath != null
                                      ? FileImage(
                                          File(imageProvider.pickImagePath!))
                                      : null,
                              child: imageProvider.pickImagePath == null
                                  ? Text(
                                      contact.name[0].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text(
                            contact.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.person,
                            color: Colors.green,
                          ),
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) {
                            return <PopupMenuEntry>[
                              PopupMenuItem(
                                onTap: () {
                                  Future.microtask(() {
                                    Provider.of<HideContactProvider>(context,
                                            listen: false)
                                        .addContact(contact);
                                    Provider.of<ContactProvider>(context,
                                            listen: false)
                                        .deleteContacts(contact);
                                  });
                                },
                                child: const Text("Hide"),
                              ),
                              PopupMenuItem(
                                onTap: () {
                                  Future.microtask(() {
                                    Provider.of<ContactProvider>(context,
                                            listen: false)
                                        .deleteContacts(contact);
                                  });
                                },
                                child: const Text("Delete"),
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AlertBox extends StatelessWidget {
  const AlertBox({Key? key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Contact"),
      content: SizedBox(
        height: 600,
        width: 300,
        child: Column(
          children: [
            Consumer<imageProvider>(
              builder: (context, step, _) {
                return CircleAvatar(
                    radius: 60,
                    backgroundImage: (step.pickImagePath != null)
                        ? FileImage(
                            File(step.pickImagePath!),
                          )
                        : null,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Pick Image",
                                ),
                                content: Text(
                                  "Choose Image From Gallery or Camera",
                                ),
                                actions: [
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: () async {
                                      await Provider.of<imageProvider>(context,
                                              listen: false)
                                          .pickPhoto();
                                      Navigator.of(context).pop();
                                    },
                                    elevation: 3,
                                    child: Icon(
                                      Icons.camera_alt,
                                    ),
                                  ),
                                  FloatingActionButton(
                                    mini: true,
                                    onPressed: () async {
                                      await Provider.of<imageProvider>(context,
                                              listen: false)
                                          .pickImage();
                                      Navigator.of(context).pop();
                                    },
                                    elevation: 3,
                                    child: Icon(
                                      Icons.image,
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      icon: Icon(Icons.camera_alt),
                    ));
              },
            ),
            const SizedBox(height: 20),
            Consumer<StepperProvider>(
              builder: (context, stepProvider, _) {
                return Stepper(
                  currentStep: stepProvider.step,
                  controlsBuilder: (context, _) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              stepProvider.forwardStep(context);
                            },
                            child:
                                Text(stepProvider.step == 2 ? "Save" : "Next"),
                          ),
                          if (stepProvider.step != 0)
                            Container(
                              margin: const EdgeInsets.only(left: 10),
                              child: OutlinedButton(
                                onPressed: stepProvider.backwardStep,
                                child: const Text("Cancel"),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                  steps: [
                    Step(
                      title: const Text("Name"),
                      content: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: stepProvider.nameController,
                            decoration: const InputDecoration(
                              hintText: "Name",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Step(
                      title: const Text("Contact"),
                      content: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: stepProvider.contactController,
                            decoration: const InputDecoration(
                              hintText: "Contact",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    Step(
                      title: const Text("Email"),
                      content: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: TextField(
                            controller: stepProvider.emailController,
                            decoration: const InputDecoration(
                              hintText: "Email",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
