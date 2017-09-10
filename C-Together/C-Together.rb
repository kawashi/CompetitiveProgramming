class Resolver 
  attr_reader :array
  
  def initialize(array)
    @array = array.sort
  end

  def execute
    calc_score_with_same_hash(array, extract_same_hash).to_s
  end

  private

  # 同一の値のハッシュを取り出す
  def extract_same_hash
    n = array.size
    i = 0
    same_hash = {}
    while( i < n )
      same_count = 1
      while( array[i] == array[i+1] )
        same_count += 1
        i += 1
      end
      same_hash.merge!({array[i] => same_count})
      i += 1
    end
    same_hash
  end

  # スコア計算する
  # 2連番の場合(n1, n2)、same_hash[n1] + same_hash[n2]
  # 1つ飛ばしの場合(n1, n3)、same_hash[n1] + same_hash[n2]
  # 3連番の場合(n1, n2, n3)、same_hash[n1] + same_hash[n2] same_hash[n3]
  def calc_score_with_same_hash(array, same_hash)
    # 同じ値の最大値でスコアを初期化する
    score = same_hash.reduce{|a, b| a[1] > b[1] ? a : b}[1]
    array.uniq!
    n = array.size
    i = 0
    while( i < n )
      # 2連番パターン
      if( array[i] + 1 == array[i+1] )
        tmp_score = same_hash[array[i]] + same_hash[array[i+1]]
        score = tmp_score if tmp_score > score
      end

      # 1つ飛ばしパターン
      if( array[i] + 2 == array[i+1] )
        tmp_score = same_hash[array[i]] + same_hash[array[i+1]]
        score = tmp_score if tmp_score > score
      end

      # 3連番パターン
      if( array[i] + 1 == array[i+1] && array[i] + 2 == array[i+2] )
        tmp_score = same_hash[array[i]] + same_hash[array[i+1]] + same_hash[array[i+2]]
        score = tmp_score if tmp_score > score
      end

      i += 1
    end

    score
  end

end

gets
array = gets.split(" ").map{|i| i.to_i}

print(Resolver.new(array).execute + "\n")