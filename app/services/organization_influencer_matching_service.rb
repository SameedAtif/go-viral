class OrganizationInfluencerMatchingService
  attr_reader :organization, :influencer, :gig

  def initialize(org_id: , influencer_id: , gig_id: )
    @organization = Organization.find(org_id)
    @influencer = Influencer.find(influencer_id)
    @gig = Gig.find(gig_id)
  end

  def match
    {
      influencer_score: similarity_score(influencer_object, organization_object),
      gig_score: similarity_score(gig_object, organization_object)
    }
  end

  private

  def similarity_score(source, org)
    present_columns = source.reject { |k| k == :start_age }.values.count(&:present?)
    # Calculate similarity for age range
    age_similarity = age_range_similarity(source, org)
    country_similarity = array_similarity(source[:country], org[:country])
    cities_similarity = array_similarity(source[:city], org[:city])
    platform_similarity = array_similarity(source[:platforms], org[:platforms])
    categories_similarity = array_similarity(source[:categories], org[:categories])

    # Combine similarities
    total_similarity = (age_similarity + country_similarity + cities_similarity + platform_similarity + categories_similarity) / present_columns.to_f
    similarity_rating = (total_similarity * 10).round(1)

    {
      total_rating: similarity_rating,
      age: age_similarity,
      country: country_similarity,
      city: cities_similarity,
      platform: platform_similarity,
      category: categories_similarity
    }
  end

  def age_range_similarity(obj1, obj2)
    return 0 if obj1[:start_age].blank? && obj2[:end_age].blank?

    age_similarity = 1 - (obj1[:start_age] - obj2[:start_age]).abs / 100.0
    age_similarity *= 1 - (obj1[:end_age] - obj2[:end_age]).abs / 100.0

    age_similarity
  end

  def array_similarity(arr1, arr2)
    return 0 if arr1.blank?

    arr_intersection = (arr1 & arr2).size
    arr_union = (arr1 | arr2).size

    arr_intersection.to_f / arr_union
  end

  def gig_object
    {
      start_age: gig.targeted_demographic_start_age,
      end_age: gig.targeted_demographic_end_age,
      country: gig.targeted_geographic_audience,
      city: gig.targeted_geographic_audience_city,
      platforms: gig.gig_platforms.includes(:platform).pluck("platforms.name"),
      categories: gig.gig_categories.includes(:category).pluck("categories.name")
    }
  end

  def influencer_object
    {
      start_age: influencer.avg_start_age,
      end_age: influencer.avg_start_age,
      country: influencer.influencer_platforms.pluck(:targeted_geographic_audience).flatten,
      city: influencer.influencer_platforms.pluck(:targeted_geographic_audience_city).flatten,
      platforms: influencer.platforms.pluck("name")
    }
  end

  def organization_object
    {
      start_age: organization.targeted_demographic_start_age,
      end_age: organization.targeted_demographic_end_age,
      country: organization.targeted_geographic_audience,
      city: organization.targeted_geographic_audience_city,
      platforms: organization.platforms,
      categories: organization.categories
    }
  end
end
