import 'dart:ui';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:momentvm/models/task.dart';
import 'package:http/http.dart' as http;
import 'package:momentvm/widgets/paged_task_list_view.dart';
import 'package:momentvm/widgets/task_tile.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/segment_provider.dart';

class NewTaskScreen extends StatefulWidget {
  final Segment segment;

  NewTaskScreen({required this.segment});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final titleController = TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  ScrollController scrollController = ScrollController();
  final searchController = TextEditingController();
  String searchPrefs = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.format_list_numbered_rtl_rounded, color: Colors.black54),
            Text(
              AppLocalizations.of(context)!.myRoutine,
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
        backgroundColor: widget.segment.listColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentNode = FocusScope.of(context);
          if (currentNode.focusedChild != null &&
              !currentNode.hasPrimaryFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.segment.backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: widget.segment.listColor.withOpacity(0.5),
                      ),
                      child: Column(children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.title,
                          ),
                          controller: titleController,
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            String curTitle = titleController.text;
                            if (curTitle.length > 80)
                              curTitle = curTitle..substring(0, 80);
                            widget.segment.addTask(title: curTitle);
                            Navigator.pop(context);
                          },
                          child: Text(AppLocalizations.of(context)!.createTask),
                        ),
                      ]),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                        bottomLeft: Radius.zero),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Container(
                        padding: const EdgeInsets.only(top: 8, bottom: 0),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                              bottomLeft: Radius.zero),
                          color: widget.segment.listColor.withOpacity(0.5),
                        ),
                        child: Column(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: SizedBox(
                              width: 220,
                              height: 40,
                              child: TextField(
                                controller: searchController,
                                textAlignVertical: TextAlignVertical.center,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      bottom: 4, right: 6),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          searchPrefs = searchController.text;
                                          print(searchPrefs);
                                        });
                                      },
                                      icon: Icon(Icons.search)),
                                  filled: true,
                                ),
                              ),
                            ),
                          ),
                          buildHeader(),
                          Expanded(
                            child: PagedTaskListView(
                                searchPref: searchPrefs,
                                segment: widget.segment),
                          )
                        ]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    //make header widget
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1.5,
            color: Color(0x17000000),
          ),
        ),
      ),
      height: 45,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              AppLocalizations.of(context)!.recommended,
              textScaleFactor: 1.2,
            ),
          )
        ],
      ),
    );
  }
}
