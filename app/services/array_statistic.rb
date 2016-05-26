class ArrayStatistic

  def self.average(array)
    return 0 if array.size == 0
    size = array.size
    sum = array.sum
    sum.fdiv(size)
  end

  def self.variance(array)
    return 0 if array.size <= 1
    size = array.size
    avg = average(array)
    quad_sum = array.inject(0){ |result, value| result + (value - avg)**2 }
    avg_quad_sum = quad_sum.fdiv(size - 1)
  end

  def self.standard_deviation(array)
    variance(array) ** 0.5
  end

  def self.covariance(array1, array2)
    return 0 if array1.size != array2.size
    return 0 if array1.size <= 1
    size = array1.size
    avg1 = average(array1)
    avg2 = average(array2)
    couples = array1.zip(array2)
    quadratic_product_sum = couples.inject(0){ |result, couple| result + ((couple[0] - avg1)*(couple[1] - avg2))}
    avg_quadratic_product_sum = quadratic_product_sum.fdiv(size - 1)
  end

  def self.pearson_correlation(array1,array2)
    return 0 if array1.size != array2.size
    return 0 if array1.size <= 1
    covariance(array1,array2).fdiv(standard_deviation(array1) * standard_deviation(array2))
  end
end
