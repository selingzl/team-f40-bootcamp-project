import 'package:flutter/material.dart';



class KvkkPage extends StatefulWidget {
  const KvkkPage({Key? key}) : super(key: key);

  @override
  _KvkkPageState createState() => _KvkkPageState();
}

class _KvkkPageState extends State<KvkkPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildSectionTitle('Kişisel Verilerin Korunması Kanunu ("KVKK") kapsamında, aşağıda açıklanan bilgiler, kişisel verilerinizin nasıl işlendiği, toplandığı, paylaşıldığı ve korunduğu hakkında size bilgi vermek amacıyla hazırlanmıştır.'),
                        _buildSectionTitle('Veri Sorumlusu'),
                        _buildInfoText('Şirket Adı: ReadMe!'),
                        _buildInfoText('Adres: ...'),
                        _buildInfoText('Telefon: ...'),
                        _buildInfoText('E-posta: ...'),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Kişisel Verilerin İşlenme Amacı'),
                        _buildInfoText('Kişisel verileriniz, aşağıda belirtilen amaçlar doğrultusunda işlenebilir:'),
                        _buildInfoText('Forum sayfası için iletişim kurma'),
                        _buildInfoText('Mail adresi ile hesap oluşturma'),
                        _buildInfoText('Mesajlar'),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Toplanan Kişisel Veriler'),
                        _buildInfoText('Aşağıda belirtilen kişisel veri kategorileri, toplandığında işlenebilir:'),
                        _buildInfoText('Temel kimlik bilgileri (ad, soyad, T.C. kimlik numarası vb.)'),
                        _buildInfoText('İletişim bilgileri (adres, telefon numarası, e-posta adresi vb.)'),
                        _buildInfoText('Finansal bilgiler (banka hesap bilgileri, kredi kartı bilgileri vb.)'),
                        _buildInfoText('Sağlık bilgileri (hastalık geçmişi, tıbbi raporlar vb.)'),
                        _buildInfoText('Diğer ilgili veriler (öğrenim durumu, iş deneyimi vb.)'),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Kişisel Verilerin Paylaşımı'),
                        _buildInfoText('Kişisel verileriniz, aşağıda belirtilen üçüncü taraflarla paylaşılabilir:'),
                        _buildInfoText('Yasal düzenlemelere uymak amacıyla resmi kurumlar ve otoriteler'),
                        _buildInfoText('İş ortakları ve hizmet sağlayıcılar'),
                        _buildInfoText('Şirket içi departmanlar ve çalışanlar'),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Kişisel Verilerin Saklanması'),
                        _buildInfoText('Kişisel verileriniz, KVKK\'ya uygun olarak belirlenen süre boyunca saklanacaktır. Verilerinizin güvenliğini sağlamak için gerekli önlemler alınacak ve yetkisiz erişimleri önlemek amacıyla teknik ve fiziksel güvenlik önlemleri uygulanacaktır.'),
                        const SizedBox(height: 20),
                        _buildSectionTitle('Kişisel Veri Sahibi Hakları'),
                        _buildInfoText('KVKK uyarınca, kişisel veri sahipleri aşağıdaki haklara sahiptir:'),
                        _buildInfoText('Kişisel verilerinizin işlenip işlenmediğini öğrenme'),
                        _buildInfoText('Kişisel verilerinizin düzeltilmesini isteme'),
                        _buildInfoText('Kişisel verilerinizin silinmesini isteme'),
                        _buildInfoText('Kişisel verilerinizin işlenmesine itiraz etme'),
                        _buildInfoText('Kişisel verilerinizin aktarıldığı üçüncü tarafları öğrenme'),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Yukarıdaki bilgileri okudum ve onaylıyorum.',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isChecked ? () =>  Navigator.pop(context) : null,
                  child: const Text('Onayla'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoText(String text) {
    return Text(text);
  }
}