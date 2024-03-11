import 'package:flutter/material.dart';

showMoodDialog(context) => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Ajouter un mood'),
        content: GridView.builder(
            gridDelegate: gridDelegate, itemBuilder: itemBuilder),
      ),
    );
