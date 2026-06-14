# Tutorial 7 - Basic 3D Game Mechanics & Level Design

Repositori ini berisi pengerjaan **Tutorial 7 - Basic 3D Game Mechanics & Level Design** untuk mata kuliah Game Development, Fakultas Ilmu Komputer, Universitas Indonesia.

Pengerjaan ini mengimplementasikan seluruh latihan utama beserta **dua (2) latihan mandiri tambahan** serta polesan mekanika permainan untuk memperoleh **nilai maksimal (4 / A)**.

---

## Fitur & Mekanika yang Diimplementasikan

### 1. Mekanika Dasar (Tutorial Utama)
- **Basic 3D Plane Movement**: Pemain dapat bergerak ke arah depan, belakang, kiri, dan kanan menggunakan tombol `W`, `A`, `S`, `D` dan melompat menggunakan tombol `Space`.
- **Mouse Look & Head Rotation**: Mengimplementasikan pergerakan kamera first-person shooter (FPS). Kamera dapat digerakkan secara bebas menggunakan mouse. Rotasi kamera dibatasi (`clamp`) sebesar -90 hingga 90 derajat secara vertikal untuk mencegah kepala berputar terbalik.
- **Object Interaction (Switch & Light)**: Menggunakan `RayCast3D` untuk mendeteksi objek interaktif di depan pemain. Pemain dapat menekan tombol `E` untuk berinteraksi dengan saklar (`Switch.gd`), yang akan menyalakan atau mematikan lampu (`OmniLight3D`) dengan mengubah tingkat energinya secara dinamis.
- **CSG Level Design**: Menggunakan Constructive Solid Geometry (CSG) Godot untuk menyusun level prototype:
  - Ruangan kosong (`Room 1` & `Room 2`) yang dibuat dari `CSGBox3D` dengan opsi `Flip Faces` dan `Use Collision` diaktifkan.
  - Lampu tidur (`CSGCombiner3D`) yang tersusun dari dasar silinder (`CSGCylinder3D`), tiang silinder, dan penutup lampu berbentuk trapesium dari hasil operasi putar (`CSGPolygon3D` mode Spin) dengan material berpendar (`Emission`).
  - Halangan / jurang (`Pit`) yang dibuat dengan mengurangkan `CSGBox3D` (operasi Subtraction) pada lantai ruangan, serta menempatkan platform melompat di tengah jurang.
- **Goal & Fall Condition**: 
  - Menggunakan `Area3D` (`AreaTrigger.gd`) untuk mendeteksi kedatangan pemain ke area finish (Goal), yang kemudian memuat scene kemenangan `WinScreen.tscn`.
  - Menggunakan `Area3D` di dasar jurang untuk mereset level kembali ke `Level 1.tscn` ketika pemain jatuh.

### 2. Eksplorasi Mechanics 3D (Latihan Mandiri - Nilai A)
- **Sprinting & Crouching (Independent Exercise 1)**:
  - **Sprinting**: Pemain dapat menahan tombol `Shift` untuk berlari dengan kecepatan dikali `1.6x` dari kecepatan normal.
  - **Crouching**: Pemain dapat menahan tombol `Ctrl` untuk berjongkok dengan kecepatan lebih lambat (`0.4x`). Ketika berjongkok, tinggi `CollisionShape3D` dan `MeshInstance3D` pemain diturunkan dari `2.0` menjadi `1.0` secara halus menggunakan fungsi interpolasi `lerp()`, serta posisi kamera (`Head`) diturunkan dari `1.5` menjadi `0.75`. Setelah melepaskan tombol, ukuran tubuh dan kamera akan kembali normal secara mulus.
- **Pick Up Item & Inventory System (Independent Exercise 2)**:
  - Membuat sistem kelas `Collectible.gd` yang diturunkan dari `Interactable.gd` untuk membuat barang yang dapat diambil.
  - Menempatkan sebuah **Key Card** di atas platform di tengah jurang. Pemain dapat membidik kartu tersebut dan menekan tombol `E` untuk mengambilnya.
  - Item yang diambil akan disimpan ke dalam array `inventory` milik script `Player.gd`.
  - **Locked Door Mechanic**: Membuat pintu besi merah besar (`LockedDoor.gd`) yang menghalangi jalan menuju ke ruang Goal. Jika pemain mencoba membukanya tanpa memiliki kartu, HUD akan menampilkan pesan peringatan `"Locked! Requires Key Card"`. Jika pemain memiliki "Key Card", pintu akan terangkat ke atas secara otomatis dengan animasi yang mulus menggunakan `Tween` (`TRANS_QUAD` & `EASE_OUT`) dan menampilkan pesan `"Door unlocked and opened!"`.

### 3. Polishing & HUD Interface (Polesan Estetika)
- Menambahkan **HUD Overlay** (`CanvasLayer`) modern di atas layar yang menampilkan:
  - **Crosshair** putih di tengah layar untuk membantu pemain membidik saklar, kartu, dan pintu.
  - **Interaction Prompt** dinamis (contoh: `[E] Toggle Light`, `[E] Pick up Key Card`, `[E] Open Locked Door`) yang berubah otomatis ketika RayCast membidik objek interaktif.
  - **Inventory List** yang melacak item yang sedang dibawa pemain secara real-time.
  - **State Indicator** untuk menampilkan status pergerakan saat ini (`Normal`, `Sprinting`, `Crouching`).
  - **Popup Message System** yang menampilkan teks peringatan/informasi sementara di bagian atas layar selama 2.5 detik.
- Membuat scene **Win Screen** yang menarik dengan background biru gelap premium, tulisan kemenangan berwarna hijau neon, dan tombol "Play Again" yang mengunci mouse kembali dan merestart game.

---

## Struktur Folder Berkas Penting

Semua berkas pengerjaan disimpan secara rapi di folder `scenes/`:
- `scenes/Interactable.gd` - Base class interaksi fisik 3D.
- `scenes/Switch.gd` - Script interaksi saklar lampu.
- `scenes/Collectible.gd` - Script interaksi pengambilan item.
- `scenes/LockedDoor.gd` - Script pintu geser dengan validasi keycard.
- `scenes/Player.gd` - Controller pemain (fisika, look, sprint, crouch, inventory).
- `scenes/RayCast3D.gd` - Logika raycast pembidikan objek dan UI prompt.
- `scenes/AreaTrigger.gd` - Logika portal perpindahan level/reset.
- `scenes/WinScreen.gd` & `scenes/WinScreen.tscn` - Layar kemenangan permainan.
- `scenes/Player.tscn` - Prefab pemain lengkap dengan kamera dan HUD.
- `scenes/World 1.tscn` - Desain level 3D menggunakan CSG dan material.
- `scenes/Level 1.tscn` - Scene utama permainan yang menggabungkan seluruh komponen.

---

## Petunjuk Kontrol Permainan

- **Bergerak**: `W` (Maju), `A` (Kiri), `S` (Mundur), `D` (Kanan)
- **Melompat**: `Space`
- **Berlari (Sprint)**: Tahan `Shift` (Kiri)
- **Jongkok (Crouch)**: Tahan `Ctrl` (Kiri)
- **Interaksi / Ambil / Buka**: Arahkan kursor ke objek lalu tekan `E`
- **Bebaskan Kursor Mouse**: Tekan `Esc` (Tombol Cancel) untuk memunculkan kembali kursor mouse demi kenyamanan. Tekan kembali untuk mengunci kursor.

---

## Referensi

1. [Godot Docs 3D](https://docs.godotengine.org/en/stable/tutorials/3d/index.html) - Dokumentasi resmi Godot mengenai pengembangan 3D.
2. [Godot First Person Starter Tutorial](https://docs.godotengine.org/en/stable/tutorials/3d/fps_tutorial/index.html) - Panduan pembuatan pergerakan FPS.
3. [Linear Interpolation (lerp) in Godot](https://docs.godotengine.org/en/stable/classes/class_vector3.html#class-vector3-method-lerp) - Panduan penggunaan lerp untuk pergerakan mulus.
4. Materi Kuliah Game Development Gasal 2025/2026, Fakultas Ilmu Komputer, Universitas Indonesia.
