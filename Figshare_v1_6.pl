#!/usr/bin/perl

use strict;
use warnings;
use File::Copy;
use File::Basename;
use File::Find::Rule;
use Archive::Zip qw(:ERROR_CODES :CONSTANTS);
use File::Spec;
use File::Path qw(make_path);
use Time::Piece;
use Time::Seconds;
use JSON;
use HTML::Entities;

# Add the JSON data as a Perl hash
my $json_text = '{
    "acoustics": ["Acoustics and Acoustical Devices"],
    "algebra": ["Algebra"],
    "algorithmic information theory": ["Coding and Information Theory"],
    "analysis": ["Numerical Analysis"],
    "analytical chemistry": ["Analytical Chemistry not elsewhere classified"],
    "applied mathematics": ["Applied Mathematics not elsewhere classified"],
    "artificial intelligence": ["Artificial Intelligence and Image Processing"],
    "astrobiology": ["Astrobiology"],
    "astrochemistry": ["Planetary Science", "Astrophysics"],
    "astrophysics": ["Astrophysics"],
    "atmospheric chemistry": ["Atmospheric Sciences not elsewhere classified"],
    "atmospheric science": ["Atmospheric Sciences"],
    "atomic and molecular physics": ["Atomic and Molecular Physics"],
    "behaviour": ["Animal Behaviour"],
    "biochemistry": ["Biochemistry"],
    "biocomplexity": ["Systems Biology", "Biochemistry and Cell Biology not elsewhere classified", "Biological Sciences not elsewhere classified"],
    "bioenergetics": ["Cell Metabolism", "Biochemistry and Cell Biology not elsewhere classified", "Biological Sciences not elsewhere classified"],
    "bioengineering": ["Biological Engineering"],
    "biogeochemistry": ["Geochemistry"],
    "biogeography": ["Biogeography and Phylogeography"],
    "biographical history": ["History"],
    "bioinformatics": ["Bioinformatics"],
    "biomaterials": ["Biomaterials"],
    "biomathematics": ["Biological Mathematics"],
    "biomechanics": ["Biomechanics"],
    "biomedical engineering": ["Biomedical Engineering not elsewhere classified"],
    "biometeorology": ["Meteorology"],
    "biometrics": ["Pattern Recognition and Data Mining", "Human Biophysics "],
    "biomimetics": ["Biomolecular modelling and design", "Biomaterials"],
    "biophysics": ["Biophysics"],
    "biotechnology": ["Biotechnology"],
    "category theory": ["Category Theory, K Theory, Homological Algebra"],
    "cellular biology": ["Cell Biology"],
    "cellular biophysics": ["Biophysics"],
    "chaos theory": ["Pure Mathematics not elsewhere classified"],
    "chemical biology": ["Biochemistry"],
    "chemical ecology": ["Environmental Chemistry", "Environmental Science"],
    "chemical engineering": ["Chemical Engineering not elsewhere classified"],
    "chemical physics": ["Physical Chemistry not elsewhere classified"],
    "civil engineering": ["Civil Engineering not elsewhere classified"],
    "climatology": ["Climatology"],
    "cognition": ["Cognitive Science not elsewhere classified"],
    "combinatorics": ["Combinatorics and Discrete Mathematics"],
    "complexity": ["Analysis of Algorithms and Complexity"],
    "computational biology": ["Computational Biology"],
    "computational chemistry": ["Theoretical and Computational Chemistry not elsewhere classified"],
    "computational mathematics": ["Numerical and Computational Mathematics not elsewhere classified"],
    "computational mechanics": ["Mechanics"],
    "computational physics": ["Computational Physics"],
    "computer graphics": ["Computer Graphics"],
    "computer modelling and simulation": ["Simulation and Modelling"],
    "computer vision": ["Computer Vision"],
    "computer-aided design": ["CAD", "Design Practice and Management no elsewhere classified"],
    "cosmology": ["Cosmology"],
    "cryptography": ["Data Encryption", "Computer System Security"],
    "crystal engineering": ["Crystallography"],
    "crystallography": ["Crystallography"],
    "cybernetics": ["Control Systems, Robotics and Automation"],
    "developmental biology": ["Developmental Biology"],
    "differential equations": ["Ordinary Differential Equations, Difference Equations and Dynamical Systems", "Partial Differential Equations", "Numerical Solution of Differential and Integral Equations"],
    "e-science": ["Organisation of Information and Knowledge Resources", "Distributed and Grid Systems"],
    "ecology": ["Ecology"],
    "eighteenth century science": ["History"],
    "electrical engineering": ["Electrical and Electronic Engineering not elsewhere classified"],
    "electromagnetism": ["Electrostatics and Electrodynamics", "Electrical and Electronic Engineering not elsewhere classified"],
    "electron microscopy": ["Nanotechnology not elsewhere classified"],
    "electrophysiology": ["Physiology not elsewhere classified"],
    "energy": ["Power and Energy Systems Engineering", "Renewable Power and Energy Systems Engineering", "Energy Generation, Conversion and Storage Engineering"],
    "engineering geology": ["Geology not elsewhere classified"],
    "environmental chemistry": ["Environmental Chemistry"],
    "environmental engineering": ["Environmental Engineering not elsewhere classified"],
    "environmental science": ["Environmental Science"],
    "evolution": ["Evolutionary Biology"],
    "extrasolar planets": ["Planetary Science"],
    "field theory": ["Field Theory and String Theory"],
    "fluid mechanics": ["Fluidisation and Fluid Mechanics"],
    "fractals": ["Mathematical Sciences not elsewhere classified"],
    "Gaia theory": ["Environmental Science"],
    "galaxies": ["Galactic Astronomy"],
    "gauge theory": ["Particle Physics"],
    "genetics": ["Genetics"],
    "genomics": ["Genomics"],
    "geochemistry": ["Geochemistry"],
    "geology": ["Geology"],
    "geometry": ["Geometry"],
    "geophysics": ["Geophysics"],
    "glaciology": ["Glaciology"],
    "graph theory": ["Pure Mathematics not elsewhere classified"],
    "green chemistry": ["Inorganic Green Chemistry", "Organic Green Chemistry"],
    "group theory": ["Group Theory and Generalisations"],
    "hadronic physics": ["Particle Physics"],
    "health and disease and epidemiology": ["Epidemiology", "Diseases", "Health Care"],
    "high-energy physics": ["Particle Physics"],
    "high-pressure physics": ["Applied Physics"],
    "history of astronomy": ["History"],
    "history of biology": ["History"],
    "history of chemistry": ["History"],
    "history of computer science": ["History"],
    "history of cross-disciplinary science": ["History"],
    "history of earth sciences": ["History"],
    "history of engineering and technology": ["History"],
    "history of mathematics": ["History"],
    "history of medical sciences": ["History"],
    "history of physics": ["History"],
    "history of psychology": ["History"],
    "history of science archives": ["History"],
    "history of scientific exploration": ["History"],
    "history of scientific institutions": ["History"],
    "human-computer interaction": ["Digital and interaction design", "Computer Software not elsewhere classified"],
    "hybrid computing": ["Computer Software not elsewhere classified"],
    "hydrology": ["Hydrology"],
    "image processing": ["Image Processing"],
    "immunology": ["Immunology"],
    "inorganic chemistry": ["Inorganic Chemistry"],
    "integral equations": ["Numerical Solution of Differential and Integral Equations"],
    "interstellar medium": ["Interstellar and Intergalactic Matter"],
    "k-theory": ["Category Theory, K Theory, Homological Algebra"],
    "Lie groups": ["Lie Groups, Harmonic and Fourier Analysis"],
    "light microscopy": ["Analytical Spectrometry"],
    "limnology": ["Limnology"],
    "low-temperature physics": ["Condensed Matter Physics", "Applied physics"],
    "Magellanic Clouds": ["Interstellar and Intergalactic Matter"],
    "materials science": ["Macromolecular and Materials Chemistry not elsewhere classified"],
    "mathematical finance": ["Financial Mathematics"],
    "mathematical logic": ["Mathematical Logic, Set Theory, Lattices and Universal Algebra"],
    "mathematical modelling": ["Mathematical Sciences not elsewhere classified"],
    "mathematical physics": ["Mathematical Physics not elsewhere classified"],
    "mechanical engineering": ["Mechanical Engineering"],
    "mechanics": ["Mechanics"],
    "medical computing": ["Health Informatics", "Biomedical Instrumentation"],
    "medical physics": ["Medical Physics"],
    "medicinal chemistry": ["Medicinal and Biomolecular Chemistry not elsewhere classified"],
    "mesoscopics": ["Soft Condensed Matter", "Condensed Matter Physics"],
    "meteorology": ["Meteorology"],
    "microbiology": ["Microbiology"],
    "microsystems": ["Microelectromechanical Systems (MEMS)"],
    "molecular biology": ["Molecular Biology"],
    "molecular computing": ["Molecular and organic electronics", "Microbiology"],
    "nanotechnology": ["Nanotechnology not elsewhere classified"],
    "nebulae": ["Interstellar and Intergalactic Matter"],
    "neuroscience": ["Neuroscience"],
    "nineteenth century science": ["History"],
    "nuclear chemistry": ["Nuclear Chemistry"],
    "nuclear physics": ["Nuclear Physics"],
    "number theory": ["Algebra and Number Theory"],
    "observational astronomy": ["Instrumentation, Techniques, and Astronomical Observations"],
    "ocean engineering": ["Ocean Engineering"],
    "oceanography": ["Oceanography"],
    "optics": ["Optical Physics not elsewhere classified"],
    "organic chemistry": ["Organic Chemistry"],
    "organometallic chemistry": ["Organometallic Chemistry"],
    "palaeontology": ["Palaeontology (incl. Palynology)"],
    "particle physics": ["Particle Physics"],
    "pattern recognition": ["Pattern Recognition and Data Mining"],
    "pedology": ["Soil Science"],
    "petrology": ["Igneous and Metamorphic Petrology", "Ore Deposit Petrology"],
    "photochemistry": ["Chemical Sciences not elsewhere classified"],
    "physical chemistry": ["Physical Chemistry not elsewhere classified"],
    "physiological optics": ["Vision science"],
    "physiology": ["Physiology"],
    "plant science": ["Plant Biology"],
    "plasma physics": ["Plasma Physics"],
    "plate tectonics": ["Tectonics"],
    "power and energy systems": ["Power and Energy Systems Engineering"],
    "pre-seventeenth century science": ["History"],
    "prime numbers": ["Algebra and Number Theory", "Pure Mathematics not elsewhere classified"],
    "psychology": ["Psychology and Cognitive Sciences not elsewhere classified"],
    "quantum computing": ["Quantum Information, Computation and Communication"],
    "quantum engineering": ["Lasers and Quantum Electronics", "Quantum Mechanics"],
    "quantum physics": ["Quantum Physics not elsewhere classified"],
    "quasars": ["Extragalactic Astronomy", "Cosmology and Extragalactic Astronomy"],
    "radiation biophysics": ["Biophysics"],
    "relativity": ["General Relativity", "Special Relativity"],
    "ring theory": ["Algebra"],
    "robotics": ["Control Systems, Robotics and Automation"],
    "sensory biophysics": ["Biophysics"],
    "set theory": ["Mathematical Logic, Set Theory, Lattices and Universal Algebra"],
    "seventeenth century science": ["History"],
    "software": ["Computer Software", "Software Engineering"],
    "solar system": ["Solar System, Solar Physics, Planets and Exoplanets"],
    "solid-state physics": ["Solid Mechanics", "Condensed Matter Physics"],
    "space exploration": ["Space Science", "Astrophysics"],
    "spectroscopy": ["Structural Chemistry and Spectroscopy"],
    "spintronics": ["Electronic and Magnetic Properties of Condensed Matter"],
    "stars": ["Stars, Variable Stars"],
    "statistical physics": ["Thermodynamics and Statistical Physics"],
    "statistics": ["Statistics"],
    "string theory": ["Field Theory and String Theory"],
    "structural biology": ["Structural Biology"],
    "structural engineering": ["Structural Engineering"],
    "supramolecular chemistry": ["Supramolecular Chemistry"],
    "synthetic biology": ["Synthetic Biology"],
    "synthetic chemistry": ["Organic Chemical Synthesis", "Synthesis of Materials"],
    "systems biology": ["Systems Biology"],
    "systems theory": ["Information Systems Theory", "Calculus of Variations, Systems Theory and Control Theory"],
    "taxonomy and systematics": ["Animal Systematics and Taxonomy", "Plant Systematics and Taxonomy"],
    "theoretical biology": ["Biological Mathematics", "Bioinformatics"],
    "theory of computing": ["Theoretical Computer Science"],
    "thermodynamics": ["Thermodynamics"],
    "topology": ["Topology"],
    "twentieth century science": ["History"],
    "twenty-first century science": ["History"],
    "vacuum physics": ["Applied Physics"],
    "volcanology": ["Volcanology"],
    "wave motion": ["Acoustics and Acoustical Devices; Waves"]
}';

my $category_map = decode_json($json_text);

opendir(DIR, "$ARGV[0]") or die "Cannot open directory: $!";
my $dir = "$ARGV[0]";
my @zipfiles = File::Find::Rule->file->name('*.zip')->in("$ARGV[0]");

print "Enter the new figshare folder name: ";
my $newoutput_dir = <STDIN>;
chomp($newoutput_dir);
my $output_dir = "$dir\\$newoutput_dir";
#print "$output_dir\n";

# Create the output directory if it doesn't exist
unless (-d $output_dir) {
    make_path($output_dir) or die "Failed to create output directory: $!";
}

for my $zip_file (@zipfiles) {
    # Create a new Archive::Zip object
    my $zip = Archive::Zip->new();

    # Read the zip file
    unless ($zip->read($zip_file) == AZ_OK) {
        die "Failed to read zip file: $!";
    }

    # Extract files to the specified directory
    foreach my $member ($zip->members) {
        my $extracted_file = File::Spec->catfile($dir, $member->fileName());

        # Create the necessary directory structure
        my ($volume, $directories, $file) = File::Spec->splitpath($extracted_file);
        unless (-d $directories) {
            make_path($directories) or die "Failed to create directories: $!";
        }

        # Extract the file
        unless ($member->extractToFileNamed($extracted_file) == AZ_OK) {
            die "Failed to extract file: " . $member->fileName();
        }
        #print "Extracted: " . $member->fileName() . "\n";
    }
}

# Process metadata XML files and store dates
my $subdate = ''; # Variable to store the date for use in XML creation

# Initialize an empty array to store the hashes
my @custom_fields_data;

# Initialize an array to store author data
my @authors;

my @tag_fields_data;

my @cat_fields_data;

my @file_data_hashes;

my $journal_abbreviation = '';

my $article_title = '';

my $description = '';

my $doi = '';

my $resource = '';

my @source_metadata_xml = File::Find::Rule->file->name('*.xml')->in($dir);

foreach my $xml_file (@source_metadata_xml) {
    open(XML, '<', $xml_file) or die "Cannot open XML file $xml_file: $!";
    my $xml_content = do { local $/; <XML> };
    close(XML);
	
# Initialize an array to store the hash of file data
my $file_counter = 1;

# Find <file> elements with the required <attribute>
    while ($xml_content =~ m|<file\s+(.*?)>(.*?)</file>|sg) {
        my $file_attributes = $1;
        my $file_content = $2;

		# Convert the content to lowercase
		my $file_content_lower = lc($file_content);

        if ($file_content_lower =~ m|<attribute\s+attr_name="file designation">electronic supplementary material \(esm\)</attribute>|) {
            my %file_data;
            if ($file_attributes =~ m|file_name="(.*?)"|) {
                $file_data{'file_name'} = $1;
            }
            if ($file_content =~ m|<file_originalname>(.*?)</file_originalname>|) {
                $file_data{'file_originalname'} = $1;
            }
            $file_data{'Counter'} = sprintf("%03d", $file_counter);

            # Store the hash in the array
            push @file_data_hashes, \%file_data;

            # Increment the counter
            $file_counter++;
        }
    }
}

# Example: Printing the captured file data
foreach my $file_hash (@file_data_hashes) {
    print "File Data:\n";
    while (my ($key, $value) = each %$file_hash) {
        print "\t$key => $value\n";
    }
}


# Find and copy files from 'suppl_data' subfolders
my @suppl_data_dirs = File::Find::Rule->directory->name('suppl_data')->in($dir);

if (@suppl_data_dirs) {
    foreach my $suppl_data_dir (@suppl_data_dirs) {
        #print "Found 'suppl_data' folder at $suppl_data_dir. Copying matching contents to $output_dir...\n";
        my @files_to_copy = File::Find::Rule->file()->in($suppl_data_dir);

        for my $file (@files_to_copy) {
            my $file_name = basename($file);
            my $lowercase_file_name = lc($file_name);  # Convert to lowercase for comparison
            my $copy_file = 0;

            #print "Checking file: $file_name\n";  # Debugging output
            #print "Lowercase file name: $lowercase_file_name\n";  # Debugging output

            # Check if the file name matches any of the entries in @file_data_hashes
            foreach my $file_data (@file_data_hashes) {
                my $file_name_to_check = lc($file_data->{'file_name'} // '');
                my $file_originalname_to_check = lc($file_data->{'file_originalname'} // '');

                #print "Comparing with file_name: $file_name_to_check\n";  # Debugging output
                #print "Comparing with file_originalname: $file_originalname_to_check\n";  # Debugging output

                if ($file_name_to_check eq $lowercase_file_name || $file_originalname_to_check eq $lowercase_file_name) {
                    $copy_file = 1;
                    last;
                }
            }

            if ($copy_file) {
                my $destination = File::Spec->catfile($output_dir, $file_name);
                if (copy($file, $destination)) {
                    #print "Copied $file to $destination\n";
                } else {
                    #warn "Failed to copy $file to $destination: $!";
                }
            } else {
                #print "Skipped $file (no match found in \@file_data_hashes)\n";
            }
        }
    }
} else {
    print "'suppl_data' folder not found in any subdirectory of $dir.\n";
}


foreach my $xml_file (@source_metadata_xml) {
    open(XML, '<', $xml_file) or die "Cannot open XML file $xml_file: $!";
    my $xml_content = do { local $/; <XML> };
    close(XML);

    if ($xml_content =~ /<submitted_date>\s*<year>(\d{4})<\/year>\s*<month>(\d{2})<\/month>\s*<day>(\d{2})<\/day>/si) {
        my $year = $1;
        my $month = $2;
        my $day = $3;
        $subdate = "$year-$month-$day";
        #print "Extracted date: $subdate\n";
    }

    if ($xml_content =~ /<journal_abbreviation>(.*?)<\/journal_abbreviation>/i) {
        $journal_abbreviation = "$1";
		$journal_abbreviation = lc($journal_abbreviation);
    }
    if ($xml_content =~ /<article_title>(.*?)<\/article_title>/is) {
        $article_title = "$1";
		$article_title = decode_entities($article_title);
    }
    if ($xml_content =~ /<abstract>(.*?)<\/abstract>/is) {
        $description = "$1";
		# Decode HTML entities
		$description = decode_entities($description);
    }
    if ($xml_content =~ /<article_id id_type=\"doi\">(.*?)<\/article_id>/i) {
        $doi = "$1";
		$resource = $doi;
		$resource =~ tr/.//d;
		$resource =~ tr/([a-z]+)//d;
		$resource =~ s/([0-9]+)\/([0-9]+)/$2/g;
    }

# Use a regex to capture all custom_fields elements
while ($xml_content =~ m/<custom_fields\s+(.*?)\/>/g) {
    my $attributes_str = $1;
    my %attributes;

    # Split the attributes and store them in the hash
    while ($attributes_str =~ m/(\w+)="(.*?)"/g) {
        $attributes{$1} = $2;
    }

    # Add the hash to the array
    push @custom_fields_data, \%attributes;
}

# Example: Printing the captured data
#foreach my $field (@custom_fields_data) {
#    print "Custom Field:\n";
#    while (my ($key, $value) = each %$field) {
#        print "\t$key => $value\n";
#    }
#}


# Collect author list '$xml_content' contains your XML data
if ($xml_content =~ m/<author_list>(.*?)<\/author_list>/s) {
    my $author_list_content = $1;

    # Capture all <author> elements inside the <author_list>
    while ($author_list_content =~ m/<author(.*?)>(.*?)<\/author>/gs) {
        my $author_content = $2;
        my %author;

        # Capture first name, middle name, and last name
        $author{'first_name'} = $1 if $author_content =~ m/<first_name>(.*?)<\/first_name>/;
        $author{'middle_name'} = $1 if $author_content =~ m/<middle_name>(.*?)<\/middle_name>/;
        $author{'last_name'} = $1 if $author_content =~ m/<last_name>(.*?)<\/last_name>/;

        # Push the hash to the authors array
        push @authors, \%author;
    }
}

# Collect Key list '$xml_content' contains your XML data
if ($xml_content =~ m/<content>(.*?)<\/content>/s) {
    my $maintag_list_content = $1;
	
	# Convert the content to lowercase
	#my $maintag_list_content_lower = lc($maintag_list_content);


	if ($maintag_list_content =~ m/<attr_type\s+(.*?)name\=\"subject area(.*?)\">(.*?)<\/attr_type>/si) {
    my $tag_list_content = $3;

    # Capture all <attribute> elements inside the <content>
    while ($tag_list_content =~ m/<attribute\s+(.*?)>selected<\/attribute>/g) {
        my $tag_content = $1;
        my %tag;

        # Split the attributes and store them in the hash
		while ($tag_content =~ m/(\w+)="(.*?)"/g) {
			$tag{$1} = $2;
		}

		# Add the hash to the array
		push @tag_fields_data, \%tag;
    }

	if ($maintag_list_content =~ m/<attr_type\s+(.*?)name\=\"(subject\s+)?categor(y|ies)(.*?)\">(.*?)<\/attr_type>/si) {
    my $cat_list_content = $5;
    # Capture all <attribute> elements inside the <content>
    while ($cat_list_content =~ m/<attribute\s+(.*?)>selected<\/attribute>/g) {
        my $cat_content = $1;
        my %cat;

        # Split the attributes and store them in the hash
		while ($cat_content =~ m/(\w+)="(.*?)"/g) {
			$cat{$1} = $2;
		}

		# Add the hash to the array
		push @cat_fields_data, \%cat;
    }
	}
	
	}
}

}

# Calculate the embargo date (7 days from today)
my $current_date = localtime;
my $embargo_date = $current_date + ONE_WEEK; # ONE_WEEK is equivalent to 7 * 86400 seconds

# Format the embargo date as YYYY-MM-DD
my $formatted_embargo_date = $embargo_date->strftime('%Y-%m-%d');

# Rename files in $output_dir and create corresponding XML files
my @output_files = File::Find::Rule->file()->in($output_dir);
my $counter = 1;


foreach my $file (@output_files) {
    my ($name, $path, $ext) = fileparse($file, qr/\.[^.]*/);
    my $uid_name = '';
    my $new_name = '';
    
    $uid_name = sprintf("%s%03d", $newoutput_dir, $counter);
    $new_name = sprintf("%s_si_%03d%s", $newoutput_dir, $counter, $ext);
    my $new_path = File::Spec->catfile($output_dir, $new_name);

    # Rename the file
    rename($file, $new_path) or die "Failed to rename $file to $new_path: $!";
    #print "Renamed $file to $new_path\n";


	# Search for the matching custom field title
		my $title_value = '';
		foreach my $field (@custom_fields_data) {
			if ($field->{'cd_code'} && $field->{'cd_code'} eq "ESM file $counter title") {
				$title_value = $field->{'cd_value'};
				# Remove any dot (.) from the title_value
				#$title_value =~ tr/.//d;
				$title_value =~ s/\.$//;
				$title_value = decode_entities($title_value);
				last;
			}
		}

	# Search for the matching custom field caption
		my $caption_value = '';
		foreach my $field (@custom_fields_data) {
			if ($field->{'cd_code'} && $field->{'cd_code'} eq "ESM file $counter caption") {
				$caption_value = $field->{'cd_value'};
				$caption_value = decode_entities($caption_value);
				last;
			}
		}

			#print "ESM file $counter title\n";


    # Check the file name against @file_data_hashes
    foreach my $file_data (@file_data_hashes) {
        if ($file_data->{'file_name'} && $file_data->{'file_name'} eq $name . $ext) {
            $counter = $file_data->{'Counter'};
			#print "File name matched with File name key value.$counter\n";
            last;
        }
        if ($file_data->{'file_originalname'} && $file_data->{'file_originalname'} eq $name . $ext) {
            $counter = $file_data->{'Counter'};
			#print "File name matched with File Original name key value.$counter\n";
            last;
        }
    }

    # Create XML file
    my $xml_file = sprintf("%s_si_%03d_metadata.xml", $newoutput_dir, $counter);
    my $xml_path = File::Spec->catfile($output_dir, $xml_file);
    open(my $fh, '>', $xml_path) or die "Cannot create XML file $xml_path: $!";
	
	# Use a default title if $title_value is empty
	$title_value = "Supplementary Material" if !$title_value || $title_value =~ /^\s*$/;

	# Use the counter to find the corresponding caption value
	if (!$caption_value || $caption_value =~ /^\s*$/) {
		# Initialize a variable to hold the original name
		my $original_name = '';

		# Search for the counter value in @file_data_hashes
		foreach my $file_data (@file_data_hashes) {
			if ($file_data->{'Counter'} && $file_data->{'Counter'} == $counter) {
				$original_name = $file_data->{'file_originalname'} // '';
				last;
			}
		}

		# If an original name is found, use it as the caption
		$caption_value = "$original_name" if $original_name;
	}

    print $fh "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
    print $fh "<figshare-si xmlns:xlink=\"https://www.w3.org/1999/xlink\">\n";
    print $fh "<uid>$uid_name</uid>\n";
    print $fh "<title>$title_value</title>\n";
    print $fh "<description>$caption_value</description>\n";
    print $fh "<license>CC-BY</license>\n";
    print $fh "<settings>\n";
    print $fh "<embargo>\n";
    print $fh "<embargoDate>$formatted_embargo_date</embargoDate>\n";  # Add the embargo date
    print $fh "<embargoReason>This content is under embargo until the article is published.</embargoReason>\n";
    print $fh "</embargo>\n";
    print $fh "</settings>\n";
    
    # Use the extracted date for submission and acceptance
    print $fh "<submission_date>$subdate</submission_date>\n";
    print $fh "<acceptance_date>$subdate</acceptance_date>\n";

    print $fh "</figshare-si>\n";
    close($fh);
    #print "Created XML file $xml_path\n";

    $counter++;
}

    # Create XML file
my $cxml_file = sprintf("%s_si_collection.xml", $newoutput_dir);
my $cxml_path = File::Spec->catfile($output_dir, $cxml_file);
open(my $sh, '>', $cxml_path) or die "Cannot create XML file $cxml_path: $!";
print $sh "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n";
print $sh "<figshare-si-collection xmlns:xlink=\"https://www.w3.org/1999/xlink\">\n";
print $sh "<group_id>$journal_abbreviation</group_id>\n";
print $sh "<title>Supplementary material from \"$article_title\"</title>\n";
print $sh "<description>$description</description>\n";
print $sh "<authors>\n";
# Now print each author's information to $sh
foreach my $author_ref (@authors) {
    print $sh "<author>";
    print $sh "<firstName>$author_ref->{'first_name'}</firstName>" if $author_ref->{'first_name'};
    print $sh "<middleName>$author_ref->{'middle_name'}</middleName>" if $author_ref->{'middle_name'};
    print $sh "<lastName>$author_ref->{'last_name'}</lastName>" if $author_ref->{'last_name'};
    print $sh "</author>\n";
}
print $sh "</authors>\n";
print $sh "<tags>\n";
foreach my $tag_ref (@tag_fields_data) {
    if ($tag_ref->{'name'}) {
        print $sh "<tag>$tag_ref->{'name'}</tag>\n";
    }
}
print $sh "</tags>\n";
print $sh "<categories>\n";

if (@cat_fields_data){
foreach my $cat_ref (@cat_fields_data) {
    if ($cat_ref->{'name'}) {
        my $found_key = '';
     
        # Search for the $cat_ref value in the hash
        while (my ($key, $values) = each %$category_map) {
            if (grep { $_ eq $cat_ref->{'name'} } @$values) {
                $found_key = $key;
                last;
            }
        }
		# Print the key if found, otherwise print the original value
        if ($found_key) {
            print $sh "<category>$found_key</category>\n";
        } else {
			print $sh "<category><!--Category not found-->$cat_ref->{'name'}</category>\n";
		}
    } 
}
}else{
	print $sh "<category><!--Category not available in metadata--></category>\n";
}
print $sh "</categories>\n";
print $sh "<resource_id>$resource</resource_id>\n";
print $sh "<resource_doi>$doi</resource_doi>\n";
print $sh "<resource_link>http://dx.doi.org/$doi</resource_link>\n";
print $sh "<resource_title>$article_title</resource_title>\n";
print $sh "<resource_version>1</resource_version>\n";
print $sh "</figshare-si-collection>\n";

close($sh);

closedir(DIR);
print "\nExtraction, copying, renaming, and Figshare XML creation process completed successfully!\n";
