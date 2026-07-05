
-- Function Set Updated At -- creates or updates timestamps for logging events

create or replace function set_updated_at()
    returns trigger as $$
    begin
        new.updated_at := now();
        return new;
    end;
$$ language plpgsql;

-- Function Sync Instrument Condition  -- updates instruments.condition_status to 'needs_repair' when entered into repairs table

create or replace function sync_instrument_condition() 
    returns trigger as $$
    begin
        update instruments
        set condition_status = 'needs _repair'
        where instrument_id = new.instrument_id;
    end if;
    return new;
end;
$$ language plpgsql;
