import 'package:flutter/material.dart';

// This class is used to create a card that can be expanded and collapsed.
class ExpandableCard extends StatefulWidget {
  final String _title; // The title of the card
  final String _subtitle; // The subtitle of the card
  final Widget _content; // The content of the card
  final Function toggleFn; // The function to toggle the card

  ExpandableCard(this._title, this._subtitle, this._content,
      {this.toggleFn}); // The constructor

  @override
  _ExpandableCardState createState() =>
      _ExpandableCardState(); // The state of the card
}

// The _ExpandableCardState class is used to create the state of the card.
class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false; // The state of the card

  void toggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

// The build method is used to create the card.
  @override
  Widget build(BuildContext context) {
    if (widget.toggleFn != null) widget.toggleFn(toggle);

    return Card(
      // The card
      child: Column(
        children: <Widget>[
          ListTile(
            // The list tile
            title: Text(widget._title),
            subtitle: Text(widget._subtitle),
            trailing: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded) // If the card is expanded, show the content
            Container(
              padding: EdgeInsets.all(10),
              child: widget._content,
            )
        ],
      ),
    );
  }
}
