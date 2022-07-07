# iReader

<!-- ABOUT THE PROJECT -->
<p align="center">
  <a href="#" target="_blank"><img src="iReader.png" width="200"></a>
</p>

Aplikasi Tasker adalah aplikasi iOS Aplikasi Barcode dan Pemindai Teks Langsung dengan SwiftUI, AVKit, dan VisionKit (On Device Machine Learning Processing).

### Preview
<p align="center">
  <a href="#" target="_blank"><img src="1.png" width="200"></a>
  <a href="#" target="_blank"><img src="2.png" width="200"></a>
  <a href="#" target="_blank"><img src="3.png" width="200"></a>
</p>

<!-- ABOUT THE FILE & FOLDER STRUCTURE -->
## Folder & File Structure
Berikut struktur file dan folder pada Tasker:

    .
    ├── iReaderApp.swift           # Root Project: Konfirgurasi AppViewModel
    ├── Info.plist                 # Privacy - Camera Usage Description
    ├── ContentView.swift          # Tampilan Beranda Aplikasi
    ├── Assets                     # Aset Logo dan Warna
    ├── AppViewModel.swift         # Berisikan Deklarasi Data Enum & Fungsi Main Thread
    └── DataScannerView.swift      # Berisikan Fungsi Wrapper DataScannerView yang disediakan oleh Apple untuk Scanning Data dengan Camera

<!-- List of Features -->
## Features:

* QR & Bar Code Scanner
* Native iOS Camera

<!-- Used Tools -->
## Build With:

* [Swift](https://www.swift.org/documentation/)
* [SwiftUI](https://developer.apple.com/documentation/swiftui/)
* [Xcode 14.0](https://developer.apple.com/xcode/)
* [VisionKit Framework](https://developer.apple.com/documentation/visionkit)
* [AVKit](https://developer.apple.com/documentation/avkit)

### Requirements
* [iOS 16.0 Beta](https://developer.apple.com/documentation/visionkit/datascannerviewcontroller?changes=_8_3)
* [Xcode 14.0](https://developer.apple.com/xcode/)

<!-- How to Install -->
## Installation
Untuk menggunakan repositori ini, ikutilah petunjuk penggunaan berikut dan pastikan git sudah terinstall pada komputer (semua perintah dilaksanakan pada `cmd.exe` atau `terminal`):

1. Lakukan download .zip atau `clone` repositori dengan cara:
```bash
git clone https://github.com/dekapd99/iReader.git
```

2. Jika sudah silahkan buka Project di Xcode.
3. Build & Run

<!-- What Kind of License? -->
## License
MIT License

Copyright (c) 2022 DK

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

<p align="right">(<a href="#top">back to top</a>)</p>
