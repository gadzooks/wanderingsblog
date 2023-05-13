
var documents = [{
    "id": 0,
    "url": "/404.html",
    "title": "404",
    "body": "404 Page does not exist!Please use the search bar at the top or visit our homepage! "
    }, {
    "id": 1,
    "url": "/about/",
    "title": "About",
    "body": "This is my attempt to document some of the most amazing places that I have been to, the people I have met and things I learnt. "
    }, {
    "id": 2,
    "url": "/about",
    "title": "Mediumish Template for Jekyll",
    "body": "&gt;This website is a place for me to document my personal experiences and share those with my family and friends and you dear stranger ! It started out with my wanting to play around with static website generators but I may use it as my personal blog. Heavily influenced by mediumish-boostrap-jekyll. "
    }, {
    "id": 3,
    "url": "/categories",
    "title": "Categories",
    "body": ""
    }, {
    "id": 4,
    "url": "/",
    "title": "Home",
    "body": "      Featured:                                                                                                                                                                                                                                         Anatomy of a picture                              :               This was one of the hardest (and luckiest) picture I have taken in a very long time. There is a lot that goes on behind. . . :                                                                                                                                                                       Amit                                14 Aug 2021                -                 1 min read                                                                                                                                                                                                                                                                                                                  Kenai Fjords National Park Alaska                              :               You know you are in for a treat when you go whale watching in the Kenai Fjords national parks in Alaska. This was my second. . . :                                                                                                                                                                       Amit                                14 Aug 2021                -                 1 min read                                                                                                                                                                                                                                                                                                                                    Yellowstone day 1                              :               We drove from Seattle to Yellowstone and entered from the northern entrance where we saw the Mammoth Hot Springs and a lot of wild life. . . . :                                                                                                                                                                       Amit                                22 Sep 2018                -                 2 min read                                                                                                                                                                                                                                                                                                                  My first solo backpacking with Baloo                              :               This was my first “solo” backpacking adventure. I decided to go on a long 4 day hike in the North Cascades and I picked a. . . :                                                                                                                                                                       Amit                                27 Aug 2017                -                 1 min read                                                                                                                            All Other Stories:                                                                                                           Kendal Peak Lake Snowshoe              :       Kendal Peak in Washington State is an iconic and breathtaking winter adventure spot. With stunning views of the lake below and majestic snow-covered peaks in the distance, a day spent. . . :                                                                               Amit                16 Mar 2023        -         1 min read                                                                                                                                               Middle Fork Trail              :       The Middle Fork Trail is a beautiful hiking option in Washington State, offering stunning views of mountains, rivers, and snow-capped peaks. This trail is renowned for its natural beauty, and. . . :                                                                               Amit                05 Mar 2023        -         1 min read                                                                                                                                               Heather Lake Trail              :         Heather lake trail  Heather lake trail  Heather lake trail  Heather lake trail  Heather lake trail:                                                                               Amit                22 Jan 2023        -         1 min read                                                                                                                                               Caño Negro Wildlife Refuge              :       Costa Rica is an incredible destination for the avid birdwatcher and animal enthusiast. The tropical wildlife refuge is home to a wide variety of birds, including some unique and rare. . . :                                                                               Amit                11 Apr 2022        -         1 min read                                                                                                                                               Costa Rica - part deux              :       I fell in love with Costa Rica the first time I went there. I was my first trip outside of the US and I was amazed by the natural beauty. . . :                                                                               Amit                10 Apr 2022        -         4 min read                                                                                                                                                               Skyline Lake Snowshoe              :       Skyline lake snowshoe is an amazing snowshoe by Stevens Pass East. It has incredible views, a frozen lake (depending on time of the year) and a beautiful rock garden at. . . :                                                                               Amit                09 Mar 2019        -         1 min read                                                                                                                                               Yellowstone 09-25 Grand Teton              :       If you’re looking to escape the hustle and bustle of everyday life and embrace the beauty of nature, then you’ll want to visit Grand Teton National Park. With towering mountains. . . :                                                                               Amit                25 Sep 2018        -         1 min read                                                                                                                                               Yellowstone day 2              :       We went on a nice hike called Hell Roaring and got to see some bison roaming around. We was pretty cool to see these huge wilder beasts roaming freely. We. . . :                                                                               Amit                22 Sep 2018        -         1 min read                                                                                                                                                               Mt Dickerman Winter Route              :        Mt Dickerman is one of the premier hikes in the Pacific North West. It is a beast of a climb but the rewards are amazing. :                                                                               Amit                05 Jun 2017        -         2 min read                                                   &laquo; Prev       1        2      Next &raquo; "
    }, {
    "id": 5,
    "url": "/robots.txt",
    "title": "",
    "body": "      Sitemap: {{ “sitemap. xml”   absolute_url }}   "
    }, {
    "id": 6,
    "url": "/page2/",
    "title": "Home",
    "body": "{% if page. url == “/” %}       Featured:       {% for post in site. posts %}    {% if post. featured == true %}      {% include featuredbox. html %}    {% endif %}  {% endfor %}  {% endif %}       All Other Stories:         {% for post in site. posts %}    {% if post. featured != true %}      {% include postbox. html %}    {% endif %}    {% endfor %}    {% include pagination. html %}"
    }, {
    "id": 7,
    "url": "/snowshoe-kendal-peak-lake-wa-state/",
    "title": "Kendal Peak Lake Snowshoe",
    "body": "2023/03/16 - Kendal Peak in Washington State is an iconic and breathtaking winter adventure spot. With stunning views of the lake below and majestic snow-covered peaks in the distance, a day spent at Kendal Peak is the perfect escape. Take in the majestic beauty of the mountains on a snowshoe trek through the untouched powder of this pristine landscape. Explore the unspoiled wilderness and spend the day playing in the snow, breathing the crisp winter air and taking in the scenery. With its secluded location and miles of untouched terrain, Kendal Peak offers the perfect winter escape for skiers and snowshoers alike. "
    }, {
    "id": 8,
    "url": "/Middle-fork-trail/",
    "title": "Middle Fork Trail",
    "body": "2023/03/05 - The Middle Fork Trail is a beautiful hiking option in Washington State, offering stunning views of mountains, rivers, and snow-capped peaks. This trail is renowned for its natural beauty, and offers plenty of opportunities for peaceful exploration. With lush meadows, craggy cliffs, and old-growth forests, the Middle Fork Trail is a great choice for those looking to explore the outdoors. With access to areas of the mountain that attract a range of wildlife, the Middle Fork Trail provides excellent wildlife viewing opportunities, particularly in the wintertime. The stunning river views, stunning mountain vistas, and exciting wildlife encounters make this a great choice for anyone looking to explore the beauty of Washington State. "
    }, {
    "id": 9,
    "url": "/Heather-lake-trail/",
    "title": "Heather Lake Trail",
    "body": "2023/01/22 -   Heather lake trail  Heather lake trail  Heather lake trail  Heather lake trail  Heather lake trail"
    }, {
    "id": 10,
    "url": "/costa-rica-vacation/",
    "title": "Caño Negro Wildlife Refuge",
    "body": "2022/04/11 - Costa Rica is an incredible destination for the avid birdwatcher and animal enthusiast. The tropical wildlife refuge is home to a wide variety of birds, including some unique and rare species, as well as sloths, monkeys and an abundance of other wildlife. From the colorful toucans and parrots, to the playful coatimundi, Costa Rica is a paradise for any nature lover. A short drive outside of the bustling city of San Jose leads visitors to the haven of natural beauty, filled with vibrant life.   costa rica0076. jpg  _DSC0916. jpg  _DSC0971. jpg  _DSC0885. jpg  _DSC0492. jpg"
    }, {
    "id": 11,
    "url": "/costa-rica-trip/",
    "title": "Costa Rica - part deux",
    "body": "2022/04/10 -  I fell in love with Costa Rica the first time I went there. I was my first trip outside of the US and I was amazed by the natural beauty and kindness of the people.  Our itinerary / high level plan Local services we used What you will need to bring with you Driving     San Jose to Arenal :   Arenal to Monte Verde :   Monte Verde to Jaco   Jaco to San Jose   Our itinerary / high level plan:       Date   Activity   Driving   Stay   Notes         1   Fly into San Jose   -   Melrost Airport B&amp;B           2   Drive to Arenal   3-4 hrs   Arenal - Volcano Lodge, Hotel &amp; Thermal Experience   Pick up car Vamos was great       3   Canoa Negro Float    Hotel Pickup   Arenal   One of the best ways to see wild life       4   Hanging Bridge, Arenal 1968   None   Arenal   1968 trail was amazing       5   Drive to Monte Verde   3-4 hours   Hotel Claro de Luna   best roads are Route 142 to Tilaran, then Route 145 to 606. This drive takes about 3. 5-4 hours (from La Fortuna) and is along a mix of paved and dirt roads       6   In Monte Verde   None   Monte Verde   https://reservacuricancha. com/ You can also give us a call at: (506) 2645-6915 / (506) 8448-8283 Starts at 6:00.        7   Drive to Jaco       Hotel Club del Mar Oceanfront   Hotel was nice. Beach town for locals.        8   Drive to San Jose       Marriott Hotel Hacienda Belen   Beautiful hotel. Great dinner and some tennis in sandals       9   Fly to Seattle       Marriott Hotel       Local services we used Car rental (Vamos). They dropped off and picked up the car from the hotels we stayed in for a very reasonable price ($20ish) Get a SIM card with Kolbi. great coverageWhat you will need to bring with you Head lamps Baby wipes ? Small hand sanitizer(s) Diarreah pills Arnica cream or gel - in case of bumps, bruises, etc - it works wonders.  Ponchos / small umbrella Money belt Sony camera + extra batteries + charger Water shoes for beach and ocean Spanish language book / dictionary / translation app Plastic bags, zip log bags Several color copies of passport Long socks , up to knees TP roll ? Take cash $400 or so each Chafing cream Bandana Small first aid kit Summit packs (2?) Travel insurance for United flightDriving Driving in CR is very peaceful. The traffic is well behaved, especially once you are out of the capital San Jose. We planned our rentals in such a way that Vamos delivered the car to us on our 1st day of the rental and picked it up on the last day from a different location. This is the way to do it instead of figuring out a way to get to their office in SJ on pickup and return. San Jose to Arenal :: San Jose to Arenal: If you are coming from San Jose, it should take you no more than 3-4 hours to get to La Fortuna, Costa Rica. Traveling west on Route 1 will take you to San Ramon where you will then take Route 702 to La Fortuna. The total driving distance from La Fortuna/Arenal to San Jose is 139 km (86 miles). Although it doesn’t sound like a long distance, the winding roads will slow you down so be sure to plan accordingly. Arenal to Monte Verde :: ￼ Monte Verde to Jaco: ￼ Jaco to San Jose: ￼ "
    }, {
    "id": 12,
    "url": "/whale-breach/",
    "title": "Anatomy of a picture",
    "body": "2021/08/14 - This was one of the hardest (and luckiest) picture I have taken in a very long time. There is a lot that goes on behind taking a picture like this one. At the minimum :  you to be at the right place (on a crowded whale watching boat deck) and at the right time (✔).  your camera settings should be correct (in this case fast shutter speed and burst mode) you need to be pointing in the right direction. This was the trickiest part since you could not really predict where the whale would breach. They seem to love diving deep in the ocean and surfacing at a different part.  assuming you have all the above ready to go, you have to make sure that you click on the trigger the moment you see the whale breaching. Too soon and your camera buffer may fill up (you made sure you are using a fast camera card right ? 😄), too late and you miss key moments. All these things came together and I was able to capture this wonderful beast, not once but twice. The 2nd time was further away and so I didnt get as good shots (though I would have been happy with just those by themselves too. )   Here is a picture of a typical whale watching boat"
    }, {
    "id": 13,
    "url": "/kenai-fjords-national-park/",
    "title": "Kenai Fjords National Park Alaska",
    "body": "2021/08/14 -  You know you are in for a treat when you go whale watching in the Kenai Fjords national parks in Alaska. This was my second time in Seward and I went with the trusted Major Marines Tours !. I think we picked the 6 or 7 hour version (the longer the better I feel) Some of the highlights of the trip were :  Seeing Humpback whales breaching and playing with each other Seeing massive glaciers up close Puffins, otters, bald eagles Amazing drinks they make off the freshly harvested ice from the glacier  I believe I can fly!"
    }, {
    "id": 14,
    "url": "/skyline-lake-snowshoe-washington-state/",
    "title": "Skyline Lake Snowshoe",
    "body": "2019/03/09 - Skyline lake snowshoe is an amazing snowshoe by Stevens Pass East. It has incredible views, a frozen lake (depending on time of the year) and a beautiful rock garden at the top. Make sure to get there early enough since parking can be limited at the Stevens Pass parking lot (just east of the pass). See www. wta. org/go-hiking/hikes/skyline-lake-snowshoe for more details.             "
    }, {
    "id": 15,
    "url": "/grand-teton/",
    "title": "Yellowstone 09-25 Grand Teton",
    "body": "2018/09/25 - If you’re looking to escape the hustle and bustle of everyday life and embrace the beauty of nature, then you’ll want to visit Grand Teton National Park. With towering mountains and breathtaking glaciers, Grand Teton offers a great opportunity to explore and get lost in some of nature’s finest wonders. The glacial valleys, wildlife, and outstanding views are among some of the highlights of the park. For anyone looking to reconnect with the natural world, Grand Teton is an ideal destination.           "
    }, {
    "id": 16,
    "url": "/yellowstone-day-2/",
    "title": "Yellowstone day 2",
    "body": "2018/09/22 -  We went on a nice hike called Hell Roaring and got to see some bison roaming around. We was pretty cool to see these huge wilder beasts roaming freely. We did make sure that we kept a healthy distance from them. "
    }, {
    "id": 17,
    "url": "/yellowstone-day-1/",
    "title": "Yellowstone day 1",
    "body": "2018/09/22 -  We drove from Seattle to Yellowstone and entered from the northern entrance where we saw the Mammoth Hot Springs and a lot of wild life. Some of the highlights of the day were :: Rivers of Yellowstone: This one was an unexpected and pleasant surprise for us. We had no idea about the beauty and serenity of the river system in Yellowstone. I could have spent a few days taking pictures and drawing them if I could. Something to do on a longer visit some day 😄   Im not into fishing but there is something very peaceful in watching these guys fly fishing  The rivers had this wonderful foreground to the great plains and majestic mountains in the distance. Mammoth Hot Springs:   Mammoth Hot Springs  Beautiful and colorful patterns  Beautiful and colorful patternsWild life:   wild life  Goat 🐐  Some kind of gazelle ?Bon Fire !!: This was on our way back to the AirBnb. Remind me to link the lovely place we stayed at. We were heading back when we saw these huge flames in the distance. As we drove closer we saw a huge communal bon fire which was about 2-3 storey high. There were a lot of people around it, having a great time. I wish I had had my better camera / lens, but these are the pictures I captured from a distance. It was one of those sights where you had to stop by the side of the road and take some pictures 😄   Huge flames  Huge flames"
    }, {
    "id": 18,
    "url": "/1st-backpacking-with-baloo/",
    "title": "My first solo backpacking with Baloo",
    "body": "2017/08/27 -  This was my first “solo” backpacking adventure. I decided to go on a long 4 day hike in the North Cascades and I picked a tough scenic one - North Fork Sauk Trail Some of the things that made this very challenging were :  My first solo trip It was about 30 miles, in high country and it was a hot summer week.  I had no idea that Baloo gets so hot and needs a lot of water himself.   Baloo resting after another long day of hiking in the hot sun  Mountains bathing in alipine glow!  Looking out into the valley  Beautiful sunset  Bear grass"
    }, {
    "id": 19,
    "url": "/mt-dickerman-winter-route/",
    "title": "Mt Dickerman Winter Route",
    "body": "2017/06/05 -  Mt Dickerman is one of the premier hikes in the Pacific North West. It is a beast of a climb but the rewards are amazing. I decided to climb via the winter route for a change. The winter route, mainly follows the summer route but towards the top instead of taking switch-backs you go straight up as the crow flies. This hike is not to be taken lightly, even in the best of situations and especially not in winter conditions.   Baloo saying - lets go hike already !Not too shabby along the way too   Blue bird day  My buddy Eric hiking up  Final Ascent  Beautiful but deadly cornices  Crowded at the top ?At the very top   Mountains as far as you can see  Winter makes everything extra magical  Doggie paradise  Snow capped mountains"
    }];

var idx = lunr(function () {
    this.ref('id')
    this.field('title')
    this.field('body')

    documents.forEach(function (doc) {
        this.add(doc)
    }, this)
});
function lunr_search(term) {
    document.getElementById('lunrsearchresults').innerHTML = '<ul></ul>';
    if(term) {
        document.getElementById('lunrsearchresults').innerHTML = "<p>Search results for '" + term + "'</p>" + document.getElementById('lunrsearchresults').innerHTML;
        //put results on the screen.
        var results = idx.search(term);
        if(results.length>0){
            //console.log(idx.search(term));
            //if results
            for (var i = 0; i < results.length; i++) {
                // more statements
                var ref = results[i]['ref'];
                var url = documents[ref]['url'];
                var title = documents[ref]['title'];
                var body = documents[ref]['body'].substring(0,160)+'...';
                document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML = document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML + "<li class='lunrsearchresult'><a href='" + url + "'><span class='title'>" + title + "</span><br /><span class='body'>"+ body +"</span><br /><span class='url'>"+ url +"</span></a></li>";
            }
        } else {
            document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML = "<li class='lunrsearchresult'>No results found...</li>";
        }
    }
    return false;
}

function lunr_search(term) {
    $('#lunrsearchresults').show( 400 );
    $( "body" ).addClass( "modal-open" );
    
    document.getElementById('lunrsearchresults').innerHTML = '<div id="resultsmodal" class="modal fade show d-block"  tabindex="-1" role="dialog" aria-labelledby="resultsmodal"> <div class="modal-dialog shadow-lg" role="document"> <div class="modal-content"> <div class="modal-header" id="modtit"> <button type="button" class="close" id="btnx" data-dismiss="modal" aria-label="Close"> &times; </button> </div> <div class="modal-body"> <ul class="mb-0"> </ul>    </div> <div class="modal-footer"><button id="btnx" type="button" class="btn btn-danger btn-sm" data-dismiss="modal">Close</button></div></div> </div></div>';
    if(term) {
        document.getElementById('modtit').innerHTML = "<h5 class='modal-title'>Search results for '" + term + "'</h5>" + document.getElementById('modtit').innerHTML;
        //put results on the screen.
        var results = idx.search(term);
        if(results.length>0){
            //console.log(idx.search(term));
            //if results
            for (var i = 0; i < results.length; i++) {
                // more statements
                var ref = results[i]['ref'];
                var url = documents[ref]['url'];
                var title = documents[ref]['title'];
                var body = documents[ref]['body'].substring(0,160)+'...';
                document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML = document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML + "<li class='lunrsearchresult'><a href='" + url + "'><span class='title'>" + title + "</span><br /><small><span class='body'>"+ body +"</span><br /><span class='url'>"+ url +"</span></small></a></li>";
            }
        } else {
            document.querySelectorAll('#lunrsearchresults ul')[0].innerHTML = "<li class='lunrsearchresult'>Sorry, no results found. Close & try a different search!</li>";
        }
    }
    return false;
}
    
$(function() {
    $("#lunrsearchresults").on('click', '#btnx', function () {
        $('#lunrsearchresults').hide( 5 );
        $( "body" ).removeClass( "modal-open" );
    });
});