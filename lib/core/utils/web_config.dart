// import 'package:flutter/material.dart';

// class WebConfig {
//   static void configureWebApp() {
//     // Add web-specific meta tags
//     if (const String.fromEnvironment('dart.library.html') != '') {
//       final head = document.head;
      
//       // Add mobile web app capable meta tag
//       final mobileWebAppCapable = Element.tag('meta')
//         ..setAttribute('name', 'mobile-web-app-capable')
//         ..setAttribute('content', 'yes');
//       head?.append(mobileWebAppCapable);
      
//       // Add viewport meta tag
//       final viewport = Element.tag('meta')
//         ..setAttribute('name', 'viewport')
//         ..setAttribute('content', 
//             'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no');
//       head?.append(viewport);
//     }
//   }
// }