class Person < ActiveRecord::Base
  include DataState

  PUBLIC_ATTRIBUTES = [:first_name, :last_name, :family_name, :birth_date,
                       :death_date, :lived, :description]

  FIELDS = [:first_name, :last_name, :family_name, :lived, :raw_record,
            :data_state, :notes]

  belongs_to :grave
  validates :lived, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  has_one :birth_date, dependent: :destroy
  has_one :death_date, dependent: :destroy
  validate :birth_before_death

  # select only people with some publicly accessible information
  def self.any_info
    includes(:birth_date).includes(:death_date).includes(:grave)
      .joins('LEFT JOIN birth_dates ON birth_dates.person_id = people.id')
      .joins('LEFT JOIN death_dates ON death_dates.person_id = people.id')
      .where("first_name IS NOT NULL OR last_name IS NOT NULL \
           OR family_name IS NOT NULL OR lived IS NOT NULL \
           OR description IS NOT NULL OR birth_dates.year IS NOT NULL \
           OR death_dates.year IS NOT NULL").order(:last_name)
  end

  def full_name
    if [first_name, last_name, family_name].any?(&:present?)
      [first_name, last_name, family_name_in_parenthesis].compact.join(' ')
    else
      'Nieznane'
    end
  end

  def to_param
    "#{id} #{full_name}".parameterize
  end

  def errors_with_dates?
    errors.any? || (birth_date && birth_date.errors.any?) ||
      (death_date && death_date.errors.any?)
  end

  def quarter
    grave.quarter if grave
  end

  def quarter_graves
    quarter ? quarter.graves.sort : Grave.quarterless.sort
  end

  private

  def family_name_in_parenthesis
    "(#{family_name})" if family_name.present?
  end

  def birth_before_death
    birth_date_ok = birth_date && !birth_date.destroyed? && birth_date.valid?
    death_date_ok = death_date && !death_date.destroyed? && death_date.valid?
    return unless birth_date_ok && death_date_ok && !birth_date.could_be_before(death_date)

    errors[:base] << I18n.t('errors.death_before_birth',
                            default: 'A man must be born before he dies')
  end
end
