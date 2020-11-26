import 'package:flutter/material.dart';

void main() {
  runApp(MultipleCategorySelection());
}

class MultipleCategorySelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text("Dialog category selector")),
        body: CategorySelector(
          ["Banana", "Pear", "Apple", "Strawberry", "Pineapple"],
        ),
      ),
    );
  }
}

class CategorySelector extends StatefulWidget {
  final List<String> categories;

  CategorySelector(this.categories);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final selectedCategories = List<String>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RaisedButton(
          child: Text("Select Fruit"),
          onPressed: () async {
            List<String> categories = await showDialog(
              context: this.context,
              child: new Dialog(
                child: CategorySelectorDialog(
                    widget.categories, List.from(selectedCategories)),
              ),
            );
            setState(() {
              selectedCategories.clear();
              selectedCategories.addAll(categories);
            });
          },
        ),
        Container(
          color: Colors.green,
          height: 2,
        ),
        SelectedCategories(
          categories: selectedCategories,
        )
      ],
    );
  }
}

class SelectedCategories extends StatelessWidget {
  final List<String> categories;

  const SelectedCategories({Key key, this.categories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(categories[index]),
            );
          }),
    );
  }
}

class CategorySelectorDialog extends StatefulWidget {
  final List<String> categories;
  final List<String> currentSelection;

  CategorySelectorDialog(this.categories, this.currentSelection);

  @override
  _CategorySelectorDialogState createState() => _CategorySelectorDialogState();
}

class _CategorySelectorDialogState extends State<CategorySelectorDialog> {
  final _selectedCategories = List<String>();

  @override
  void initState() {
    _selectedCategories.addAll(widget.currentSelection);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: ListView.builder(
              itemCount: widget.categories.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  value: _selectedCategories.contains(widget.categories[index]),
                  onChanged: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedCategories.add(widget.categories[index]);
                      } else {
                        _selectedCategories.remove(widget.categories[index]);
                      }
                    });
                  },
                  title: Text(widget.categories[index]),
                );
              }),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pop(context, widget.currentSelection);
          },
          child: Text("Cancel"),
        ),
        RaisedButton(
          onPressed: () {
            Navigator.pop(context, _selectedCategories);
          },
          child: Text("Done"),
        )
      ],
    );
  }
}
