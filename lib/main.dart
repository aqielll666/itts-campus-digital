import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITTS Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
      ),
      home: const MainLayout(),
    );
  }
}

// ====================================================================
// 1. MAIN LAYOUT
// ====================================================================
class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Tab ke-3 sekarang memanggil ProfilePage()
  final List<Widget> _pages = [
    const HomeDashboard(),
    const Center(child: Text('Halaman Notifikasi\n(Belum ada pesan baru)', textAlign: TextAlign.center, style: TextStyle(fontSize: 18))),
    const ProfilePage(), 
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifikasi'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

// ====================================================================
// 2. HALAMAN PROFIL (BARU)
// ====================================================================
class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Controller untuk menangkap inputan teks
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();

  // Variabel untuk menyimpan data profil
  String _nama = "";
  String _nim = "";
  String _prodi = "";
  
  // Status apakah profil sudah dibuat atau belum
  bool _isProfileCreated = false;

  @override
  void dispose() {
    // Selalu bersihkan controller saat tidak digunakan untuk mencegah memory leak
    _namaController.dispose();
    _nimController.dispose();
    _prodiController.dispose();
    super.dispose();
  }

  void _simpanProfil() {
    // Validasi sederhana: pastikan tidak ada yang kosong
    if (_namaController.text.isEmpty || _nimController.text.isEmpty || _prodiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua data!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _nama = _namaController.text;
      _nim = _nimController.text;
      _prodi = _prodiController.text;
      _isProfileCreated = true; // Mengubah tampilan ke mode "Lihat Profil"
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil disimpan!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Mahasiswa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: colorScheme.primary,
        centerTitle: true,
      ),
      // Tampilkan form pengisian JIKA profil belum dibuat, sebaliknya tampilkan Kartu Profil
      body: _isProfileCreated ? _buildProfileCard(colorScheme) : _buildProfileForm(colorScheme),
    );
  }

  // WIDGET UNTUK FORM PENGISIAN
  Widget _buildProfileForm(ColorScheme colorScheme) {
    return ListView(
      padding: const EdgeInsets.all(25.0),
      children: [
        const Text(
          'Buat Profil Anda',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        const Text(
          'Silakan lengkapi data diri Anda di bawah ini.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 30),
        
        TextField(
          controller: _namaController,
          decoration: const InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person)),
        ),
        const SizedBox(height: 20),
        
        TextField(
          controller: _nimController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'NIM', border: OutlineInputBorder(), prefixIcon: Icon(Icons.badge)),
        ),
        const SizedBox(height: 20),
        
        TextField(
          controller: _prodiController,
          decoration: const InputDecoration(labelText: 'Program Studi', border: OutlineInputBorder(), prefixIcon: Icon(Icons.book)),
        ),
        const SizedBox(height: 30),
        
        ElevatedButton.icon(
          onPressed: _simpanProfil,
          icon: const Icon(Icons.save),
          label: const Text('Simpan Profil', style: TextStyle(fontSize: 16)),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15),
          ),
        ),
      ],
    );
  }

  // WIDGET UNTUK MENAMPILKAN PROFIL JIKA SUDAH DISIMPAN
  Widget _buildProfileCard(ColorScheme colorScheme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: colorScheme.primaryContainer,
              child: Icon(Icons.person, size: 80, color: colorScheme.primary),
            ),
            const SizedBox(height: 20),
            Text(_nama, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              decoration: BoxDecoration(color: colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(20)),
              child: Text('NIM: $_nim', style: TextStyle(fontSize: 16, color: colorScheme.onSecondaryContainer, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 10),
            Text(_prodi, style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 40),
            OutlinedButton.icon(
              onPressed: () {
                setState(() {
                  _isProfileCreated = false; // Kembali ke mode form untuk mengedit
                });
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
            )
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// 3. HALAMAN DASHBOARD UTAMA (Sama seperti sebelumnya)
// ====================================================================
class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  int _jumlahMahasiswa = 1250;

  void _tampilFormTambahMahasiswa(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Agar pop-up menyesuaikan keyboard
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Mencegah tertutup keyboard
            left: 20, right: 20, top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Simulasi Tambah Mahasiswa', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const TextField(decoration: InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder(), prefixIcon: Icon(Icons.person))),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity, height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
                  onPressed: () {
                    setState(() { _jumlahMahasiswa++; });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mahasiswa berhasil ditambahkan!'), backgroundColor: Colors.green));
                  },
                  child: const Text('Simpan Data', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('ITTS Campus Digital', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)), backgroundColor: colorScheme.primary, centerTitle: true, elevation: 2),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          Row(
            children: [
              CircleAvatar(radius: 30, backgroundColor: colorScheme.primary, child: const Icon(Icons.school, size: 30, color: Colors.white)),
              const SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Selamat Datang di Portal', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                  Text('Tangerang Selatan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: colorScheme.primary, height: 1.2)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 25),
          Card(
            elevation: 4, shadowColor: colorScheme.shadow.withOpacity(0.2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [colorScheme.primaryContainer, colorScheme.surface])),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text('Statistik Akademik', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: colorScheme.onPrimaryContainer)), Icon(Icons.analytics_outlined, color: colorScheme.primary)]),
                    const SizedBox(height: 20), const Divider(), const SizedBox(height: 20),
                    Text('$_jumlahMahasiswa', style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900, color: colorScheme.primary, letterSpacing: -2)),
                    Text('Total Mahasiswa Aktif', style: TextStyle(fontSize: 16, color: colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text('Layanan Mahasiswa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800])),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMenuInteractive(context, Icons.library_books, 'KRS', Colors.orange),
              _buildMenuInteractive(context, Icons.assignment_turned_in, 'Nilai', Colors.green),
              _buildMenuInteractive(context, Icons.schedule, 'Jadwal', Colors.blue),
              _buildMenuInteractive(context, Icons.payments, 'UKT', Colors.red),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _tampilFormTambahMahasiswa(context),
        label: const Text('Daftar Mhs Baru'), icon: const Icon(Icons.person_add_alt_1), backgroundColor: colorScheme.primary, foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildMenuInteractive(BuildContext context, IconData icon, String label, Color color) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MenuDetailPage(menuName: label, menuColor: color, menuIcon: icon)));
      },
      borderRadius: BorderRadius.circular(15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 60, width: 60,
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: color.withOpacity(0.5), width: 1)),
              child: Center(child: Icon(icon, color: color, size: 28)),
            ),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

// ====================================================================
// 4. HALAMAN DETAIL MENU
// ====================================================================
class MenuDetailPage extends StatelessWidget {
  final String menuName;
  final Color menuColor;
  final IconData menuIcon;

  const MenuDetailPage({Key? key, required this.menuName, required this.menuColor, required this.menuIcon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail $menuName', style: const TextStyle(color: Colors.white)), backgroundColor: menuColor, iconTheme: const IconThemeData(color: Colors.white)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(menuIcon, size: 100, color: menuColor), const SizedBox(height: 20),
            Text('Ini adalah halaman khusus untuk layanan:\n$menuName', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Kembali ke Dashboard'))
          ],
        ),
      ),
    );
  }
}