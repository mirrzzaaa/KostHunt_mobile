import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  final void Function(Map<String, dynamic>) onApplyFilter;
  const FilterPage({super.key, required this.onApplyFilter});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  String? selectedTipe;
  String? selectedGender;
  int? minPrice;
  int? maxPrice;

  Widget _toggle(String label, String? group, void Function(String) set) {
    final s = label == group;
    return GestureDetector(
      onTap: () => setState(() => set(label)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: s ? const Color(0xFF0A2A56) : Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(label,
            style: TextStyle(
                color: s ? Colors.white : Colors.grey.shade800,
                fontWeight: s ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _price(String hint, void Function(String) set) => Expanded(
        child: TextField(
          keyboardType: TextInputType.number,
          onChanged: set,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            hintStyle: const TextStyle(color: Colors.grey),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              borderSide: BorderSide(color: Color(0xFF0A2A56)),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0A2A56),
        elevation: 0,
        title:
            const Text('Filter', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text('Tipe Sewa',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(children: [
              _toggle('kos', selectedTipe, (v) => selectedTipe = v),
              _toggle('kontrak', selectedTipe, (v) => selectedTipe = v),
            ]),
            const SizedBox(height: 16),
            const Text('Jenis Kelamin',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Wrap(children: [
              _toggle('putra', selectedGender, (v) => selectedGender = v),
              _toggle('putri', selectedGender, (v) => selectedGender = v),
              _toggle('campur', selectedGender, (v) => selectedGender = v),
            ]),
            const SizedBox(height: 16),
            const Text('Batas Harga (Rp)',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Row(children: [
              _price('MIN', (v) => minPrice = int.tryParse(v)),
              const SizedBox(width: 12),
              _price('MAX', (v) => maxPrice = int.tryParse(v)),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: LayoutBuilder(
        builder: (context, c) {
          final bool isNarrow = c.maxWidth < 360; // layar kecil?
          const double btnH = 48; // tinggi tombol

          // tombol “Atur Ulang” (outline)
          final resetBtn = SizedBox(
            height: btnH,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black26),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                setState(() {
                  selectedTipe = selectedGender = null;
                  minPrice = maxPrice = null;
                });
                widget.onApplyFilter({});
                Navigator.pop(context);
              },
              child: const Text(
                'Atur Ulang',
                style: TextStyle(
                  color: Color(0xFF0A2A56),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );

          // tombol “Filter” (filled)
          final applyBtn = SizedBox(
            height: btnH,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A2A56),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: () {
                if (minPrice != null &&
                    maxPrice != null &&
                    minPrice! > maxPrice!) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('MIN tidak boleh lebih besar dari MAX'),
                    ),
                  );
                  return;
                }
                widget.onApplyFilter({
                  'tipe': selectedTipe,
                  'gender': selectedGender,
                  'minPrice': minPrice,
                  'maxPrice': maxPrice,
                });
                Navigator.pop(context);
              },
              child:
                  const Text('Filter', style: TextStyle(color: Colors.white)),
            ),
          );

          // baris untuk lebar normal, kolom untuk layar sempit
          return Padding(
            padding: const EdgeInsets.all(16),
            child: isNarrow
                ? Column(
                    children: [
                      resetBtn,
                      const SizedBox(height: 12),
                      applyBtn,
                    ],
                  )
                : Row(
                    children: [
                      Expanded(child: resetBtn),
                      const SizedBox(width: 12),
                      Expanded(child: applyBtn),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
