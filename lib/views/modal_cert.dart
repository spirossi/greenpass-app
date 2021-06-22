import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:greenpass_app/consts/colors.dart';
import 'package:greenpass_app/consts/vibration.dart';
import 'package:greenpass_app/elements/colored_card.dart';
import 'package:greenpass_app/elements/pass_info.dart';
import 'package:greenpass_app/green_validator/model/validation_result.dart';
import 'package:greenpass_app/green_validator/payload/cert_entry_recovery.dart';
import 'package:greenpass_app/green_validator/payload/cert_entry_test.dart';
import 'package:greenpass_app/green_validator/payload/cert_entry_vaccination.dart';
import 'package:greenpass_app/green_validator/payload/certificate_type.dart';
import 'package:greenpass_app/green_validator/payload/green_certificate.dart';
import 'package:greenpass_app/green_validator/payload/test_result.dart';
import 'package:greenpass_app/green_validator/payload/test_type.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

class ModalCert extends StatelessWidget {
  final ValidationResult cert;

  ModalCert({Key? key, required this.cert}) : super(key: key) {
    if (cert.success)
      GPVibration.success();
    else
      GPVibration.error();
  }

  @override
  Widget build(BuildContext context) {
    Color cardColor = cert.success ? GPColors.blue : GPColors.red;

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => Navigator.of(context).pop(),
          ),
          middle: Text('Certificate'.tr()),
        ),
        child: SafeArea(
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Column(
              children: [
                ColoredCard.build(
                  backgroundColor: cardColor,
                  padding: const EdgeInsets.all(20.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Container(
                                  margin: const EdgeInsets.all(20.0),
                                  padding: const EdgeInsets.all(20.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(150),
                                    border: Border.all(width: 4, color: Colors.white),
                                  ),
                                  child: Icon(
                                    _getCertIcon(cert),
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                )
                            ),
                          ],
                        ),
                        if (cert.success) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              PassInfo.getTypeText(cert.certificate!),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                PassInfo.getDate(cert.certificate!),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(35.0),
                                child: Text(
                                  PassInfo.getDuration(cert.certificate!),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Invalid'.tr(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    'This QR code is invalid. Please try to scan another one.'.tr(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                if (cert.success) ...[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ListTile(
                      leading: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesome5Solid.user,
                            size: 30,
                            color: GPColors.almost_black,
                          ),
                        ],
                      ),
                      title: Text(
                        cert.certificate!.personInfo.fullName,
                        style: TextStyle(
                          color: GPColors.almost_black,
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold
                        )
                      ),
                      subtitle: Text(
                        DateFormat('dd.MM.yyyy').format(cert.certificate!.personInfo.dateOfBirth),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15.0
                        )
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCertIcon(ValidationResult cert) {
    if (!cert.success)
      return FontAwesome5Solid.times;
    switch (cert.certificate!.certificateType) {
      case CertificateType.vaccination:
        return FontAwesome5Solid.syringe;
      case CertificateType.recovery:
        return FontAwesome5Solid.child;
      case CertificateType.test:
        return FontAwesome5Solid.vial;
      case CertificateType.unknown:
        return FontAwesome5Solid.times;
    }
  }

}
