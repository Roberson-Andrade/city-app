import 'dart:collection';

import 'package:city/model/irregularity.dart';
import 'package:city/model/user.dart';
import 'package:flutter/material.dart';

class IrregularityRepository extends ChangeNotifier {
  final List<Irregularity> _irregularities = [];

  UnmodifiableListView<Irregularity> get irregularities =>
      UnmodifiableListView(_irregularities);

  IrregularityRepository() {
    _irregularities.addAll([
      Irregularity(
        description: "Poste de luz está queimado há 2 semanas.",
        address: "Rua Valerio Ronchi, 701, Santa Cruz, BH",
        imagesUrl: [
          "https://araraquaraagora.com/images/noticias/11247/10035730_Img0_600x4.jpg"
        ],
        likes: 2334,
        createdAt: DateTime.parse("2024-04-01T21:00:00.000Z"),
        user: User(
            name: "Emerson Lacerda",
            avatarImage:
                "https://media.licdn.com/dms/image/C4D03AQGXwGU-r226ew/profile-displayphoto-shrink_200_200/0/1648961368675?e=2147483647&v=beta&t=ctBv_RMY0E7oCPu_p4Bmdleed7tblPSiFRWR1nf29aA"),
      ),
      Irregularity(
        description:
            "Este terreno encontra-se em estado de abandono há meses, representando um risco à segurança pública e um foco potencial de proliferação de pragas e criminalidade. Solicito uma intervenção urgente por parte da prefeitura para resolver essa situação e garantir a segurança e o bem-estar da comunidade local.",
        address: "Rua Pedro Aluisio, 321, Rebouças - PR",
        imagesUrl: [
          "https://odia.ig.com.br/_midias/jpg/2018/04/26/img_20170810_122004294_hdr-6553832.jpg"
        ],
        likes: 3,
        createdAt: DateTime.now().subtract(Duration(hours: 4)),
        user: User(
            name: "Davi",
            avatarImage:
                "https://media-gru1-2.cdn.whatsapp.net/v/t61.24694-24/269518911_718594735993943_6375134144921858972_n.jpg?ccb=11-4&oh=01_ASCp-1nuvqr_uqqsQsd_T_qKQ8rAa4eqNWwZNNEc3v3tlQ&oe=661FABD0&_nc_sid=e6ed6c&_nc_cat=104"),
      ),
    ]);
  }

  List<Irregularity> getIrregularities() {
    return irregularities;
  }

  void saveIrregularity(Irregularity irregularity) {
    _irregularities.insert(0, irregularity);
  }

  void deleteIrregularity(String id) {
    _irregularities.removeWhere((element) => element.id == id);
  }

  List<Irregularity> getIrregularitiesByName(String userName) {
    return irregularities
        .where((element) => element.user.name == userName)
        .toList();
  }
}
