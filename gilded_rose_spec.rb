require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe '#update_quality' do
    it 'does not change the name' do
      items = [Item.new('foo', 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items[0].name).to eq 'foo'
    end

    it 'decreases sell_in value by 1 for all types of goods' do
      items = [Item.new('foo', 1, 1), Item.new('Aged Brie', 1, 1), Item.new('Backstage passes to a TAFKAL80ETC concert', 1, 1), Item.new('Conjured', 1, 1)]
      GildedRose.new(items).update_quality()
      expect(items.map(&:sell_in)).to eq [0, 0, 0, 0]
    end

    it 'never decreases quality to a negative number' do
      items = [Item.new('foo', 2, 0), Item.new('foo', 0, 0), Item.new('Aged Brie', 2, 0), Item.new('Aged Brie', 0, 0), Item.new('Backstage passes to a TAFKAL80ETC concert', 2, 0), Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 0), Item.new('Conjured', 2, 0), Item.new('Conjured', 0, 0)]
      GildedRose.new(items).update_quality()
      expect(items.map(&:quality)).to eq [0, 0, 1, 2, 3, 0, 0, 0]
    end

    it 'never changes quality for Sulfuras' do
      items = [Item.new('Sulfuras, Hand of Ragnaros', 0, 80), Item.new('Sulfuras, Hand of Ragnaros', 2, 80), Item.new('Sulfuras, Hand of Ragnaros', 14, 80)]
      GildedRose.new(items).update_quality()
      expect(items.map(&:quality)).to eq [80, 80, 80]
    end

    context 'sell_in has not expired' do
      it 'decreases quality by 1 for goods other than Sulfuras, Aged Brie and Backstage passes' do
        items = [Item.new('foo', 2, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 1
      end

      it 'decreases quality by 2 for Conjured goods' do
        items = [Item.new('Conjured', 2, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end

      it 'increases quality by 1 for Aged Brie' do
        items = [Item.new('Aged Brie', 2, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 3
      end

      it 'increases quality by 1 for Backstage passes if sell_in is more than 10' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 11, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 3
      end

      it 'increases quality by 2 for Backstage passes if sell_in is less than 10 but greater than 5' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 4
      end

      it 'increases quality by 3 for Backstage passes if sell_in is less than 5' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 5, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 5
      end
    end

    context 'sell_in has expired' do
      it 'decreases quality by 2 for goods other than Sulfuras, Aged Brie and Backstage passes' do
        items = [Item.new('foo', 0, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end

      it 'decreases quality by 4 for Conjured goods' do
        items = [Item.new('Conjured', 0, 4)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 0
      end

      it 'increases quality by 2 for Aged Brie' do
        items = [Item.new('Aged Brie', 0, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq 4
      end

      it 'decreases quality to 0 for Backstage passes' do
        items = [Item.new('Backstage passes to a TAFKAL80ETC concert', 0, 2)]
        GildedRose.new(items).update_quality()
        expect(items[0].quality).to eq(0)
      end
    end

  end
end
