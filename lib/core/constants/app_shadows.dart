import 'package:flutter/material.dart';

/// Shadow System for Salon Manager App
/// Matching React app design: sm, md, lg, glow, gold
class AppShadows {
  // Small Shadow - subtle elevation
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x141A1816), // 8% opacity dark
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: -2,
    ),
  ];

  // Medium Shadow - standard cards
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x1F1A1816), // 12% opacity dark
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: -8,
    ),
  ];

  // Large Shadow - modal dialogs, bottom sheets
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x291A1816), // 16% opacity dark
      offset: Offset(0, 16),
      blurRadius: 48,
      spreadRadius: -12,
    ),
  ];

  // Glow Effect - Primary color glow
  static const List<BoxShadow> glow = [
    BoxShadow(
      color: Color(0x33D4775E), // Primary 20% opacity
      offset: Offset(0, 0),
      blurRadius: 40,
      spreadRadius: 0,
    ),
  ];

  // Gold Glow - Gold color glow
  static const List<BoxShadow> goldGlow = [
    BoxShadow(
      color: Color(0x4DD4A853), // Gold 30% opacity
      offset: Offset(0, 0),
      blurRadius: 40,
      spreadRadius: 0,
    ),
  ];

  // Rose Glow - Rose color glow
  static const List<BoxShadow> roseGlow = [
    BoxShadow(
      color: Color(0x40D47B8E), // Rose 25% opacity
      offset: Offset(0, 0),
      blurRadius: 40,
      spreadRadius: 0,
    ),
  ];

  // Sage Glow - Sage color glow
  static const List<BoxShadow> sageGlow = [
    BoxShadow(
      color: Color(0x337BA38C), // Sage 20% opacity
      offset: Offset(0, 0),
      blurRadius: 40,
      spreadRadius: 0,
    ),
  ];

  // Extra Large Shadow - prominent elements
  static const List<BoxShadow> xl = [
    BoxShadow(
      color: Color(0x331A1816), // 20% opacity dark
      offset: Offset(0, 20),
      blurRadius: 64,
      spreadRadius: -16,
    ),
  ];

  // No Shadow - flat design
  static const List<BoxShadow> none = [];
}
