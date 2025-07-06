<?php
class Pembayaran
{
    private $table = "pembayaran";

    public $id, $pemesanan_id, $jumlah, $metode, $status, $tanggal_pembayaran;

    private $conn;

    public function __construct($db)
    {
        $this->conn = $db;
    }

    public function create()
    {
        $query = "INSERT INTO $this->table 
                  (pemesanan_id, jumlah, metode, status, tanggal_pembayaran)
                  VALUES (:pemesanan_id, :jumlah, :metode, :status, NOW())";

        $stmt = $this->conn->prepare($query);
        return $stmt->execute([
            ':pemesanan_id' => $this->pemesanan_id,
            ':jumlah' => $this->jumlah,
            ':metode' => $this->metode,
            ':status' => $this->status ?? 'menunggu'
        ]);
    }

    public function getByPemesanan($pemesanan_id)
    {
        $query = "SELECT * FROM pembayaran WHERE pemesanan_id = :pemesanan_id";
        $stmt = $this->conn->prepare($query); // Gunakan $this->conn
        $stmt->bindParam(':pemesanan_id', $pemesanan_id);
        $stmt->execute();
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }

}
?>