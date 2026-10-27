import 'package:flutter/material.dart';
import 'services/api_service.dart';

void main() => runApp(const BankingApp());

final api = ApiService();
const navy = Color(0xFF142B4A);
const blue = Color(0xFF246BFD);

class BankingApp extends StatelessWidget {
  const BankingApp({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title: 'Mobile Banking', debugShowCheckedModeBanner: false,
    theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: blue), useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFF5F7FB)),
    home: const LoginPage(),
  );
}

String money(dynamic value) {
  final amount = (value is num ? value : num.tryParse('$value') ?? 0).toInt();
  final s = amount.toString();
  final out = StringBuffer();
  for (int i=0; i<s.length; i++) {
    out.write(s[i]);
    final remain=s.length-i-1;
    if (remain>0 && remain%3==0) out.write('.');
  }
  return 'Rp$out';
}

void toast(BuildContext context, String message) =>
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override State<LoginPage> createState()=>_LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final user=TextEditingController(text:'umam');
  final pass=TextEditingController(text:'Password123!');
  bool loading=false, obscure=true;
  Future<void> submit() async {
    if (user.text.trim().isEmpty || pass.text.isEmpty) { toast(context,'Username dan password wajib diisi'); return; }
    setState(()=>loading=true);
    try {
      await api.login(user.text.trim(),pass.text);
      if (!mounted) return;
      Navigator.pushReplacement(context,MaterialPageRoute(builder:(_)=>const HomePage()));
    } catch(e) { if(mounted) toast(context,e.toString().replaceFirst('Exception: ','')); }
    finally { if(mounted) setState(()=>loading=false); }
  }
  @override Widget build(BuildContext context)=>Scaffold(body:SafeArea(child:Center(child:SingleChildScrollView(
    padding:const EdgeInsets.all(24),child:ConstrainedBox(constraints:const BoxConstraints(maxWidth:420),child:Column(
      crossAxisAlignment:CrossAxisAlignment.stretch,children:[
        Container(height:76,width:76,alignment:Alignment.center,decoration:BoxDecoration(color:navy,borderRadius:BorderRadius.circular(22)),
          child:const Icon(Icons.account_balance,color:Colors.white,size:38)),
        const SizedBox(height:28),const Text('Selamat datang',style:TextStyle(fontSize:30,fontWeight:FontWeight.bold,color:navy)),
        const SizedBox(height:8),const Text('Masuk ke Mobile Banking Anda',style:TextStyle(color:Colors.blueGrey)),
        const SizedBox(height:28),TextField(controller:user,decoration:const InputDecoration(labelText:'Username',prefixIcon:Icon(Icons.person_outline),border:OutlineInputBorder())),
        const SizedBox(height:16),TextField(controller:pass,obscureText:obscure,onSubmitted:(_)=>submit(),decoration:InputDecoration(labelText:'Password',prefixIcon:const Icon(Icons.lock_outline),border:const OutlineInputBorder(),suffixIcon:IconButton(icon:Icon(obscure?Icons.visibility:Icons.visibility_off),onPressed:()=>setState(()=>obscure=!obscure)))),
        const SizedBox(height:24),FilledButton(onPressed:loading?null:submit,style:FilledButton.styleFrom(backgroundColor:navy,padding:const EdgeInsets.symmetric(vertical:16)),child:loading?const SizedBox(height:20,width:20,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)):const Text('Masuk')),
        const SizedBox(height:16),const Text('Demo: umam / Password123!',textAlign:TextAlign.center,style:TextStyle(color:Colors.blueGrey)),
      ])))))
  );
}

class HomePage extends StatefulWidget { const HomePage({super.key}); @override State<HomePage> createState()=>_HomePageState(); }
class _HomePageState extends State<HomePage> {
  Map<String,dynamic>? data; bool loading=true;
  Future<void> load() async { try { final d=await api.balance(); if(mounted)setState(()=>data=d); } catch(e){if(mounted)toast(context,e.toString());} finally{if(mounted)setState(()=>loading=false);} }
  @override void initState(){super.initState();load();}
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Mobile Banking'),backgroundColor:Colors.white,actions:[IconButton(tooltip:'Keluar',onPressed:()=>Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder:(_)=>const LoginPage()),(_)=>false),icon:const Icon(Icons.logout))]),
    body:RefreshIndicator(onRefresh:load,child:ListView(padding:const EdgeInsets.all(20),children:[
      const Text('Ringkasan rekening',style:TextStyle(fontSize:23,fontWeight:FontWeight.bold,color:navy)),
      const SizedBox(height:16),Container(padding:const EdgeInsets.all(24),decoration:BoxDecoration(gradient:const LinearGradient(colors:[navy,Color(0xFF2764A5)]),borderRadius:BorderRadius.circular(24)),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        const Text('SALDO TERSEDIA',style:TextStyle(color:Colors.white70,letterSpacing:1.2)),
        const SizedBox(height:10),Text(loading?'Memuat...':money(data?['balance']??0),style:const TextStyle(color:Colors.white,fontSize:30,fontWeight:FontWeight.bold)),
        const SizedBox(height:18),const Text('Nomor rekening',style:TextStyle(color:Colors.white70)),
        Text(data?['accountNumber']?.toString()??'-',style:const TextStyle(color:Colors.white,fontSize:17,fontWeight:FontWeight.w600))
      ])),
      const SizedBox(height:26),const Text('Aksi cepat',style:TextStyle(fontWeight:FontWeight.bold,fontSize:18)),
      const SizedBox(height:12),Row(children:[
        Expanded(child:ActionTile(icon:Icons.swap_horiz,title:'Transfer',onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>TransferPage(onDone:load))))),
        const SizedBox(width:12),Expanded(child:ActionTile(icon:Icons.receipt_long,title:'Riwayat',onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const HistoryPage())))),
      ]),
      const SizedBox(height:22),const Text('Informasi',style:TextStyle(color:Colors.blueGrey)),const SizedBox(height:6),
      const Text('Aplikasi demo untuk simulasi transfer antar rekening. Tidak terhubung ke bank sungguhan.',style:TextStyle(color:Colors.blueGrey)),
    ])));
}
class ActionTile extends StatelessWidget {
  final IconData icon; final String title; final VoidCallback onTap;
  const ActionTile({super.key,required this.icon,required this.title,required this.onTap});
  @override Widget build(BuildContext context)=>InkWell(onTap:onTap,borderRadius:BorderRadius.circular(18),child:Container(padding:const EdgeInsets.all(20),decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(18),border:Border.all(color:const Color(0xFFE5EAF2))),child:Column(children:[Icon(icon,color:blue,size:30),const SizedBox(height:10),Text(title,style:const TextStyle(fontWeight:FontWeight.w600))])));
}

class TransferPage extends StatefulWidget { final Future<void> Function() onDone; const TransferPage({super.key,required this.onDone}); @override State<TransferPage> createState()=>_TransferPageState(); }
class _TransferPageState extends State<TransferPage> {
  final target=TextEditingController(); final amount=TextEditingController(); final desc=TextEditingController(text:'Transfer demo'); bool loading=false;
  Future<void> submit() async {
    final n=int.tryParse(amount.text.replaceAll('.','').replaceAll(',',''));
    if(target.text.trim().isEmpty || n==null || n<=0){toast(context,'Isi rekening tujuan dan nominal yang valid');return;}
    setState(()=>loading=true);
    try { final result=await api.transfer(target.text.trim(),n,desc.text.trim()); await widget.onDone(); if(!mounted)return; toast(context,'Transfer berhasil: ${result['referenceNumber']}'); Navigator.pop(context); }
    catch(e){if(mounted)toast(context,e.toString().replaceFirst('Exception: ',''));}
    finally{if(mounted)setState(()=>loading=false);}
  }
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Transfer antar rekening')),body:ListView(padding:const EdgeInsets.all(20),children:[
    const Text('Detail transfer',style:TextStyle(fontSize:23,fontWeight:FontWeight.bold,color:navy)),const SizedBox(height:20),
    TextField(controller:target,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Nomor rekening tujuan',hintText:'Contoh: 1000000002',border:OutlineInputBorder(),prefixIcon:Icon(Icons.account_box_outlined))),
    const SizedBox(height:16),TextField(controller:amount,keyboardType:TextInputType.number,decoration:const InputDecoration(labelText:'Nominal (Rupiah)',hintText:'100000',border:OutlineInputBorder(),prefixIcon:Icon(Icons.payments_outlined))),
    const SizedBox(height:16),TextField(controller:desc,decoration:const InputDecoration(labelText:'Berita transfer',border:OutlineInputBorder(),prefixIcon:Icon(Icons.notes))),
    const SizedBox(height:24),FilledButton(onPressed:loading?null:submit,style:FilledButton.styleFrom(padding:const EdgeInsets.symmetric(vertical:16)),child:loading?const CircularProgressIndicator():const Text('Kirim transfer')),
    const SizedBox(height:12),const Text('Transfer hanya untuk rekening demo yang terdaftar di backend.',style:TextStyle(color:Colors.blueGrey))
  ]));
}

class HistoryPage extends StatefulWidget { const HistoryPage({super.key}); @override State<HistoryPage> createState()=>_HistoryPageState(); }
class _HistoryPageState extends State<HistoryPage> {
  List<dynamic> items=[]; bool loading=true;
  Future<void> load() async {try{final r=await api.transactions();if(mounted)setState(()=>items=r);}catch(e){if(mounted)toast(context,e.toString());}finally{if(mounted)setState(()=>loading=false);}}
  @override void initState(){super.initState();load();}
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Riwayat transaksi')),body:loading?const Center(child:CircularProgressIndicator()):items.isEmpty?const Center(child:Text('Belum ada transaksi')):RefreshIndicator(onRefresh:load,child:ListView.separated(padding:const EdgeInsets.all(12),itemCount:items.length,separatorBuilder:(_,__)=>const SizedBox(height:8),itemBuilder:(context,i){
    final t=Map<String,dynamic>.from(items[i] as Map);
    return Card(child:ListTile(leading:CircleAvatar(backgroundColor:const Color(0xFFE8F0FF),child:const Icon(Icons.swap_horiz,color:blue)),title:Text(money(t['amount']),style:const TextStyle(fontWeight:FontWeight.bold)),subtitle:Text('${t['sourceAccount']} → ${t['targetAccount']}\n${t['description']??''}'),isThreeLine:true,trailing:const Icon(Icons.chevron_right),onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>TransactionDetailPage(id:t['id'] as int)))));
  })));
}

class TransactionDetailPage extends StatefulWidget { final int id; const TransactionDetailPage({super.key,required this.id}); @override State<TransactionDetailPage> createState()=>_TransactionDetailPageState(); }
class _TransactionDetailPageState extends State<TransactionDetailPage> {
  Map<String,dynamic>? data; String? error;
  @override void initState(){super.initState();api.transactionDetail(widget.id).then((v){if(mounted)setState(()=>data=v);}).catchError((e){if(mounted)setState(()=>error=e.toString());});}
  @override Widget build(BuildContext context)=>Scaffold(appBar:AppBar(title:const Text('Detail transaksi')),body:Padding(padding:const EdgeInsets.all(20),child:error!=null?Center(child:Text(error!)):data==null?const Center(child:CircularProgressIndicator()):Card(child:Padding(padding:const EdgeInsets.all(20),child:Column(mainAxisSize:MainAxisSize.min,crossAxisAlignment:CrossAxisAlignment.start,children:[
    const Text('Nominal transaksi',style:TextStyle(color:Colors.blueGrey)),Text(money(data!['amount']),style:const TextStyle(fontSize:28,fontWeight:FontWeight.bold,color:navy)),
    const Divider(height:28),detailRow('Referensi',data!['referenceNumber']),detailRow('Dari rekening',data!['sourceAccount']),detailRow('Ke rekening',data!['targetAccount']),detailRow('Deskripsi',data!['description']),detailRow('Status',data!['status']),detailRow('Waktu',data!['createdAt'])
  ])))));
}
Widget detailRow(String label,dynamic value)=>Padding(padding:const EdgeInsets.symmetric(vertical:7),child:Row(crossAxisAlignment:CrossAxisAlignment.start,children:[SizedBox(width:120,child:Text(label,style:const TextStyle(color:Colors.blueGrey))),Expanded(child:Text(value?.toString()??'-',style:const TextStyle(fontWeight:FontWeight.w600)))]));
