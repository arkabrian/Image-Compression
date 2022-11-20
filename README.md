# Image-Compression
Sebuah aplikasi yang diciptakan sebagai proyek akhir mata kuliah Perancangan Sistem Digital kelompok A7.

Aplikasi ini akan membuat sebuah image menjadi lebih kecil menggunakan metode yang mirip dengan Chroma Subsampling. 
Pada dasarnya, sebuah image terdiri dari kumpulan beberapa pixel. Kemudian, program ini akan membagi rata pixel - pixel tersebut menjadi beberapa kelompok pixel. 
Contoh, sebuah image 27 x 27 akan dibagi rata menjadi beberapa 3x3 pixel. Selanjutnya, program akan mencari nilai rata - rata dari semua pixel di kelompok tersebut
dan menjadikannya satu pixel warna yang baru untuk dibentuk pada gambar baru. Hal ini akan diulang beberapa kali ke seluruh kelompok pixel untuk menciptakan gambar
baru yang lebih kecil.

Untuk memudahkan pembacaan image, maka format yang akan diterima hanya format BMP (Bitmap). Hal ini disebabkan format tersebut akan menyimpan RGB Value setiap pixelnya
dalam bentuk binary. Hal ini tidak berlaku pada format lain seperti JPG/JPEG dan PNG yang telah terjadi kompresi sehingga RGB Value setiap pixel tidak bisa didapatkan.
