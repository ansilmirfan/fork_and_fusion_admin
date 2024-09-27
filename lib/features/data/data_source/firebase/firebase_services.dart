// ignore_for_file: unnecessary_cast

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:fork_and_fusion_admin/core/error/exception/exceptions.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';

class FirebaseServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  //------------create -----------
  Future<void> create(String collection, Map<String, dynamic> data) async {
    try {
      //-----------checking for duplicate----------------

      final docs = await _firestore
          .collection(collection)
          .where('name', isEqualTo: data['name'])
          .get();

      if (docs.docs.isNotEmpty) {
        throw 'the given name field already exist.Please provide another name';
      }
      //------------------------
      final doc = await _firestore.collection(collection).add(data);
      await _firestore
          .collection(collection)
          .doc(doc.id)
          .update({'id': doc.id});
    } on FirebaseException catch (e) {
      throw Exceptions.handleFireBaseException(e);
    } catch (e) {
      throw e.toString();
    }
  }

//--------------------read-----------------------
  Future<List<Map<String, dynamic>>> getAll(String collection) async {
    try {
      final snapshot = await _firestore.collection(collection).get();
      final data = snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
      return data;
    } on FirebaseException catch (e) {
      throw Exceptions.handleFireBaseException(e);
    } catch (e) {
      throw e.toString();
    }
  }
  //----------------update few field--------------

  Future<bool> updateFewFileds(
      String collection, String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(id).update(data);
      return true;
    } on FirebaseException catch (e) {
      throw Exceptions.handleFireBaseException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //-------------is category deletable-----------------
  Future<bool> isDeletable(String categoryId) async {
    try {
      var data = await _firestore
          .collection('products')
          .where('category', arrayContains: categoryId)
          .get();
      return data.docs.isEmpty;
    } on FirebaseException catch (e) {
      throw Exceptions.handleFireBaseException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //--------------read one-----------------------
  Future<Map<String, dynamic>> getOne(String collection, String id) async {
    try {
      final snapshot = await _firestore.collection(collection).doc(id).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
      throw 'could not find the data';
    } on FirebaseException catch (e) {
      throw Exceptions.handleFireBaseException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //----------------------edit--------------
  Future<bool> edit(
      String id, String collection, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(collection).doc(id).update(data);
      return true;
    } on FirebaseException catch (e) {
      throw Exceptions.handleFireBaseException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //-----------------delete----------------
  Future<bool> delete(String id, String collection) async {
    try {
      await _firestore.collection(collection).doc(id).delete();
      return true;
    } on FirebaseException catch (e) {
      throw Exceptions.handleFireBaseException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //-------------search---------------------
  Future<List<Map<String, dynamic>>> search(
      String collection, String querry) async {
    try {
      final snapshot = await _firestore
          .collection(collection)
          .where('name', isGreaterThanOrEqualTo: querry)
          .where('name', isLessThanOrEqualTo: '$querry\uf8ff')
          .get();
      final data =
          snapshot.docs.map((e) => e.data() as Map<String, dynamic>).toList();

      return data;
    } on FirebaseException catch (e) {
      throw Exceptions.handleFireBaseException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //--------------upload image--------------------
  Future<String> uploadImage(File image, String path) async {
    try {
      String fileName = Utils.extractFileName(image.path);
      String filePath = 'images/$path/$fileName';
      await _storage.ref(filePath).putFile(image);
      String url = await _storage.ref(filePath).getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw Exceptions.handleFireBaseException(e);
    } catch (e) {
      throw e.toString();
    }
  }

  //------------delete image--------------------
  Future<bool> deleteImage(String url) async {
    try {
      final reference = _storage.refFromURL(url);

      await reference.delete();
      return true;
    } on FirebaseException catch (e) {
      throw Exceptions.handleFireBaseException(e);
    } catch (e) {
      throw e.toString();
    }
  }
}
