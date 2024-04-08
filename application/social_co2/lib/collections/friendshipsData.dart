import 'package:flutter/material.dart';

const List<Map<String, dynamic>> availablesUsersList = [
  {
    "type": "friends",
    "name": 'Amis',
    'icon': Icons.people,
  },
  {
    "type": "friendRequests",
    "name": 'Demandes d\'ami',
    'icon': Icons.person_add
  },
  {
    "type": "pendingRequests",
    "name": 'Demandes en attente',
    'icon': Icons.schedule,
  },
  {
    "type": "blockedUsers",
    "name": 'Utilisateurs bloqués',
    'icon': Icons.block,
  },
];
