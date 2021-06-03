class SintomaModel {
  int sintomaId;
  String img;
  String title;
  bool isCheck;

  SintomaModel({this.sintomaId, this.img, this.title, this.isCheck});
  static List<SintomaModel> getSintomas() {
    return <SintomaModel>[
      SintomaModel(
          sintomaId: 1,
          img: 'assets/images/fever.png',
          title: "Fiebre",
          isCheck: false),
      SintomaModel(
          sintomaId: 2,
          img: 'assets/images/fever.png',
          title: "Tos",
          isCheck: false),
      SintomaModel(
          sintomaId: 3,
          img: 'assets/images/fever.png',
          title: "Malestar",
          isCheck: false),
      SintomaModel(
          sintomaId: 4,
          img: 'assets/images/fever.png',
          title: "Congestión nasal",
          isCheck: false),
      SintomaModel(
          sintomaId: 5,
          img: 'assets/images/fever.png',
          title: "Pérdida del gusto / olfato",
          isCheck: false),
    ];
  }
}