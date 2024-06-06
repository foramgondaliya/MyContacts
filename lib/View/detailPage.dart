import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mycontacts/Modal/contact.dart';
import 'package:mycontacts/Provider/contact_provider.dart';
import 'package:mycontacts/Provider/imageProvider.dart';
import 'package:mycontacts/Provider/stepper_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Contact contact = ModalRoute.of(context)!.settings.arguments as Contact;
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 700,
            color: Colors.green,
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 25, right: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                width: 230,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.star_border,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          final stepperProvider =
                                              Provider.of<StepperProvider>(
                                                  context,
                                                  listen: false);
                                          stepperProvider.nameController =
                                              TextEditingController(
                                                  text: contact.name);
                                          stepperProvider.contactController =
                                              TextEditingController(
                                                  text: contact.contact);
                                          stepperProvider.emailController =
                                              TextEditingController(
                                                  text: contact.email);

                                          return AlertDialog(
                                            title: const Text("Edit Contact"),
                                            content: SizedBox(
                                              height: 600,
                                              width: 300,
                                              child: Column(
                                                children: [
                                                  Consumer<imageProvider>(
                                                    builder:
                                                        (context, step, _) {
                                                      return CircleAvatar(
                                                          radius: 60,
                                                          backgroundImage:
                                                              (step.pickImagePath !=
                                                                      null)
                                                                  ? FileImage(
                                                                      File(step
                                                                          .pickImagePath!),
                                                                    )
                                                                  : null,
                                                          child: IconButton(
                                                            onPressed: () {
                                                              showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (context) {
                                                                    return AlertDialog(
                                                                      title:
                                                                          Text(
                                                                        "Pick Image",
                                                                      ),
                                                                      content:
                                                                          Text(
                                                                        "Choose Image From Gallery or Camera",
                                                                      ),
                                                                      actions: [
                                                                        FloatingActionButton(
                                                                          mini:
                                                                              true,
                                                                          onPressed:
                                                                              () async {
                                                                            await Provider.of<imageProvider>(context, listen: false).pickPhoto();
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          elevation:
                                                                              3,
                                                                          child:
                                                                              Icon(
                                                                            Icons.camera_alt,
                                                                          ),
                                                                        ),
                                                                        FloatingActionButton(
                                                                          mini:
                                                                              true,
                                                                          onPressed:
                                                                              () async {
                                                                            await Provider.of<imageProvider>(context, listen: false).pickImage();
                                                                            Navigator.of(context).pop();
                                                                          },
                                                                          elevation:
                                                                              3,
                                                                          child:
                                                                              Icon(
                                                                            Icons.image,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    );
                                                                  });
                                                            },
                                                            icon: Icon(Icons
                                                                .camera_alt),
                                                          ));
                                                    },
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Consumer<StepperProvider>(
                                                    builder: (context, provider,
                                                        child) {
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          TextField(
                                                            controller: provider
                                                                .nameController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText: "Name",
                                                            ),
                                                          ),
                                                          TextField(
                                                            controller: provider
                                                                .contactController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Contact",
                                                            ),
                                                          ),
                                                          TextField(
                                                            controller: provider
                                                                .emailController,
                                                            decoration:
                                                                InputDecoration(
                                                              labelText:
                                                                  "Email",
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Cancel"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  final provider = Provider.of<
                                                          StepperProvider>(
                                                      context,
                                                      listen: false);
                                                  contact.name = provider
                                                      .nameController.text;
                                                  contact.contact = provider
                                                      .contactController.text;
                                                  contact.email = provider
                                                      .emailController.text;

                                                  Provider.of<ContactProvider>(
                                                          context,
                                                          listen: false)
                                                      .updateContact(contact);
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("Save"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.edit,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                  PopupMenuButton(
                                    color: Colors.white,
                                    itemBuilder: (context) {
                                      return <PopupMenuEntry>[
                                        PopupMenuItem(
                                          onTap: () {
                                            Provider.of<ContactProvider>(
                                                    context,
                                                    listen: false)
                                                .deleteContacts(contact);
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    '/', (route) => false);
                                          },
                                          child: Text("Delete"),
                                        ),
                                        PopupMenuItem(
                                          onTap: () {
                                            // Provider.of(context)
                                          },
                                          child: Text("Theme"),
                                        ),
                                      ];
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30, top: 40),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Consumer<imageProvider>(
                                  builder: (context, imageProvider, _) {
                                    return CircleAvatar(
                                      radius: 70,
                                      backgroundImage:
                                          imageProvider.pickImagePath != null
                                              ? FileImage(File(
                                                  imageProvider.pickImagePath!))
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        contact.name,
                        style: TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 350,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15), topLeft: Radius.circular(30)),
              color: Color(0xfffaf9fe),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Row(
                      children: [
                        Text(
                          contact.contact,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Phone",
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () async {
                              await launchUrl(
                                  Uri.parse("tel:${contact.contact}"));
                            },
                            icon: const Icon(
                              Icons.phone,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(color: Colors.grey.shade400),
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(Uri.parse("sms:${contact.contact}"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          Icon(Icons.message),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Message +91 ${contact.contact}",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await launchUrl(Uri.parse(
                          "mailto:${contact.email}?subject=dummy&body=this is dummy"));
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          Icon(Icons.email),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Email ${contact.email}",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      ShareExtend.share(
                          "Name : ${contact.name}\nContact : ${contact.contact}",
                          "text");
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        children: [
                          Icon(Icons.share),
                          Padding(
                            padding: const EdgeInsets.only(left: 30),
                            child: Text(
                              "Share +91 ${contact.contact}",
                              style: TextStyle(fontSize: 25),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
