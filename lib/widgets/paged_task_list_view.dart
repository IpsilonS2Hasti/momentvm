import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../models/segment_provider.dart';

class PagedTaskListView extends StatefulWidget {
  final String searchPref;
  final Segment segment;

  const PagedTaskListView(
      {Key? key, required this.searchPref, required this.segment})
      : super(key: key);

  @override
  State<PagedTaskListView> createState() => _PagedTaskListViewState();
}

class _PagedTaskListViewState extends State<PagedTaskListView> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final _pagingController = PagingController<DocumentSnapshot?, dynamic>(
    firstPageKey: null,
  );

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(DocumentSnapshot? pageKey) async {
    int limitAmount = 12;
    QuerySnapshot querySnapshot;
    if (widget.searchPref == "") {
      if (pageKey == null) {
        querySnapshot = await firestore
            .collection("published_tasks")
            .orderBy('popularity', descending: true)
            .limit(limitAmount)
            .get();
      } else {
        querySnapshot = await firestore
            .collection("published_tasks")
            .orderBy('popularity', descending: true)
            .limit(limitAmount)
            .startAfterDocument(pageKey)
            .get();
      }
      querySnapshot.docs.toList();
      if (querySnapshot.docs.length < limitAmount) {
        _pagingController.appendLastPage(querySnapshot.docs.toList());
      } else {
        final nextPageKey = querySnapshot.docs.toList().last;
        _pagingController.appendPage(querySnapshot.docs.toList(), nextPageKey);
      }
    } else {
      querySnapshot = await firestore
          .collection("published_tasks")
          .orderBy('popularity', descending: true)
          .get();
      var newList = querySnapshot.docs.toList().where((e) {
        String _title = e["title"];
        return _title.toLowerCase().contains(widget.searchPref.toLowerCase());
      }).toList();
      _pagingController.appendLastPage(newList);
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PagedTaskListView oldWidget) {
    if (oldWidget.searchPref != widget.searchPref) {
      _pagingController.refresh();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => Future.sync(
        () => _pagingController.refresh(),
      ),
      child: PagedListView(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, doc, index) => buildRecItem(doc),
          firstPageErrorIndicatorBuilder: (context) => ErrorIndicator(
            error: _pagingController.error,
            onTryAgain: () => _pagingController.refresh(),
          ),
          noItemsFoundIndicatorBuilder: (context) => EmptyListIndicator(),
        ),
      ),
    );
  }

  Widget buildRecItem(dynamic doc) {
    return Material(
      color: const Color(0x00000000),
      child: InkWell(
        onTap: () {
          int pop = doc["popularity"];
          pop++;
          firestore
              .doc("published_tasks/${doc.id}")
              .update({"popularity": pop});
          widget.segment.addTask(title: doc["title"]);
          Navigator.pop(context);
        },
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(width: 1.5, color: Color(0x17000000)),
            ),
          ),
          height: 75,
          child: Center(
            child: Row(children: [
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  doc["title"],
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

Widget EmptyListIndicator() {
  return Text("Empty!");
}

ErrorIndicator({error, required void Function() onTryAgain}) {
  return Text("Error!");
}
