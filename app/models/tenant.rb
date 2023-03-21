class Tenant < ApplicationRecord
    has_many :leases, dependent: :destroy
    has_many :apartments, through: :leases

    # Validations
    validates :name, presence: true
    validate :age_must_be_greater_than_or_equal_to_18

    def age_must_be_greater_than_or_equal_to_18
      if age.present? && age < 18
        errors.add(:age, "must be greater than or equal to 18")
      end
    end
end
