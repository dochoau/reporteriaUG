CREATE OR REPLACE FUNCTION working_hours_diff(start_time TIMESTAMP, end_time TIMESTAMP)
RETURNS NUMERIC AS $$
DECLARE
    work_date DATE := start_time::DATE;
    total_minutes INTEGER := 0;
    work_start TIME;
    work_end TIME;
    break_start_1 TIME;
    break_end_1 TIME;
    break_start_2 TIME;
    break_end_2 TIME;
    day_start TIMESTAMP;
    day_end TIMESTAMP;
    ts TIMESTAMP;
BEGIN
    WHILE work_date <= end_time::DATE LOOP
        IF EXTRACT(DOW FROM work_date) BETWEEN 1 AND 5 THEN
            -- Lunes a viernes
            work_start := TIME '08:00';
            work_end := TIME '17:30';
            break_start_1 := TIME '09:30';
            break_end_1 := TIME '10:00';
            break_start_2 := TIME '13:00';
            break_end_2 := TIME '14:00';
        ELSIF EXTRACT(DOW FROM work_date) = 6 THEN
            -- Sábado
            work_start := TIME '08:00';
            work_end := TIME '12:30';
            break_start_1 := TIME '09:30';
            break_end_1 := TIME '10:00';
            break_start_2 := NULL;
            break_end_2 := NULL;
        ELSE
            -- Domingo (no se trabaja)
            work_date := work_date + INTERVAL '1 day';
            CONTINUE;
        END IF;

        day_start := GREATEST(start_time, work_date + work_start);
        day_end := LEAST(end_time, work_date + work_end);

        IF day_start < day_end THEN
            FOR ts IN SELECT generate_series(day_start, day_end - INTERVAL '1 minute', INTERVAL '1 minute') LOOP
                IF (ts::TIME < break_start_1 OR ts::TIME >= break_end_1)
                   AND (break_start_2 IS NULL OR ts::TIME < break_start_2 OR ts::TIME >= break_end_2) THEN
                    total_minutes := total_minutes + 1;
                END IF;
            END LOOP;
        END IF;

        work_date := work_date + INTERVAL '1 day';
    END LOOP;

    RETURN ROUND(total_minutes / 60.0, 2);
END;
$$ LANGUAGE plpgsql;
