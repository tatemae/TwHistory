class UpdateCharacterTweetsJob
  attr_accessor :character_id
  
  def initialize(character_id)
    self.character_id = character_id
  end
  
  def perform
    character = Character.find(character_id) rescue nil
    if character && character.authentication
      character.items.untweeted.each do |item|
        item.export_to_twitter
      end
    end
  end

  def self.enqueue(character_id)
    Delayed::Job.enqueue UpdateCharacterTweetsJob.new(character_id)
  end
end