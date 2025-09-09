import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> transactionData = [
  {
    'icon': FontAwesomeIcons.burger,
    'name': 'Food',
    'totalAmount': '-£45.00',
    'date': 'Today',
  },

  {
    'icon': FontAwesomeIcons.bagShopping,
    'name': 'Shopping',
    'totalAmount': '-£743.00',
    'date': 'Today',
  },
  {
    'icon': FontAwesomeIcons.heartCircleCheck,
    'name': 'Health',
    'totalAmount': '-£293.00',
    'date': 'yesterday',
  },
  {
    'icon': FontAwesomeIcons.car,
    'name': 'Road Tax',
    'totalAmount': '-£93.00',
    'date': 'yesterday',
  },
  {
    'icon': FontAwesomeIcons.plane,
    'name': 'Travel',
    'totalAmount': '-£63.00',
    'date': 'yesterday',
  },
  {
    'icon': FontAwesomeIcons.graduationCap,
    'name': 'Education',
    'totalAmount': '-£93.00',
    'date': 'yesterday',
  },
];

List<Map<String, dynamic>> AvailableIcons = [
  {'icon': FontAwesomeIcons.briefcase, 'name': 'work'},
  {'icon': FontAwesomeIcons.person, 'name': 'person'},
  {
    'icon': FontAwesomeIcons.triangleExclamation,
    'name': 'warning',
  },
  {
    'icon': FontAwesomeIcons.dumbbell,
    'name': 'fitness centre',
  },
  {'icon': FontAwesomeIcons.book, 'name': 'book'},
  {
    'icon': FontAwesomeIcons.graduationCap,
    'name': 'Education',
  },
  {'icon': FontAwesomeIcons.burger, 'name': 'food'},
  {
    'icon': FontAwesomeIcons.bagShopping,
    'name': 'Shopping',
  },
  {
    'icon': FontAwesomeIcons.heartCircleCheck,
    'name': 'Health',
  },
  {'icon': FontAwesomeIcons.car, 'name': 'Road Tax'},
  {'icon': FontAwesomeIcons.plane, 'name': 'Travel'},
  {
    'icon': FontAwesomeIcons.houseChimney,
    'name': 'utilities',
  },
  {'icon': FontAwesomeIcons.mobile, 'name': 'pets'},
  {'icon': FontAwesomeIcons.church, 'name': 'pets'},
  {'icon': FontAwesomeIcons.film, 'name': 'pets'},
  {'icon': FontAwesomeIcons.children, 'name': 'pets'},
  {'icon': FontAwesomeIcons.mosque, 'name': 'pets'},
  {
    'icon': FontAwesomeIcons.moneyBillTrendUp,
    'name': 'salary',
  },
  {'icon': FontAwesomeIcons.gifts, 'name': 'gifts'},
  {'icon': FontAwesomeIcons.paw, 'name': 'pets'},
];
