require 'meta_search/builder'

MetaSearch::Builder.class_eval do
  def search_attributes_set?
    attrs_without_sort = search_attributes.select { |k,v| k != 'meta_sort' }
    !attrs_without_sort.values.all?(&:blank?)
  end
end
