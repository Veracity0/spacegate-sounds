import "relay/choice.ash";

string modify_spacegate( string page_text )
{
    int head = page_text.index_of( "</head>" );
    if ( head < 0 ) {
	return page_text;
    }

    buffer page;
    page.append( page_text );

    // Insert reference to our Javascript support package
    page.insert( head, "\n<script src=\"/spacegate_sounds.js\"></script>\n" );

    // Build Javascript to add the event handlers after we know all the form ids
    buffer script;
    script.append( "\n<script language=\"Javascript\" type=\"text/javascript\">" );

    // Add ids to all forms so we can add event handlers to them programatically
    string find = "<form action=choice.php method=post";
    matcher m = create_matcher( find, page.to_string() );
    int count = 0;

    page.set_length( 0 );

    while ( m.find() ) {
	string id = "'form" + (++count) + "'";
	string replacement = find + " id=" + id;
	m.append_replacement( page, replacement );
	script.append( "addPlaySoundSubmitListener(" + id + ");" );
    }
    m.append_tail( page );

    script.append( "</script>\n" );

    int end = page.index_of( "</html>" );
    page.insert( end, script.to_string() );
    
    return page.to_string();
}

void main(string page_text_encoded)
{
    string page_text = page_text_encoded.choiceOverrideDecodePageText();
    // string [string] form_fields = form_fields();
    if ( get_property( "relayAddSounds" ).to_boolean() ) {
	if ( page_text.contains_text( "<form" ) ) {
	    page_text = modify_spacegate( page_text );
	}
    }
    write(page_text);
}
