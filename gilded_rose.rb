class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      update_daily_quality(item)
      update_daily_sellin(item)
    end
  end

  private

    def update_daily_quality(item)
      case item.name
      when 'Aged Brie'
        increase_quality_for_product(item)
        increase_quality_for_product(item) if (item.sell_in == 0)
      when 'Backstage passes to a TAFKAL80ETC concert'
        if ((item.sell_in - 1) < 0)
          item.quality = 0
        else
          increase_quality_for_product(item)
          increase_quality_for_product(item) if item.sell_in < 11
          increase_quality_for_product(item) if item.sell_in < 6
        end
      when 'Sulfuras, Hand of Ragnaros'
        # Quality does not change for Sulfuras
      when 'Conjured'
        decrease_quality_for_product(item, 2)
        decrease_quality_for_product(item, 2) if (item.sell_in == 0)
      else
        decrease_quality_for_product(item)
        decrease_quality_for_product(item) if (item.sell_in == 0)
      end
    end

    def update_daily_sellin(item)
      case item.name
      when 'Sulfuras, Hand of Ragnaros'
        # Sell In does not matter for Sulfuras
      else
        item.sell_in = item.sell_in - 1
      end
    end

    def increase_quality_for_product(item, count=1)
      if item.quality < 50
        item.quality = item.quality + count
      end
    end

    def decrease_quality_for_product(item, count=1)
      if item.quality > 0
        item.quality = item.quality - count
      end
    end

end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
