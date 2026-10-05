library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(scales)

cars <- read.csv("data/used_cars.csv", stringsAsFactors = FALSE)

brand_list <- c("All", sort(unique(cars$Brand)))
model_list <- c("All", sort(unique(cars$Model)))
fuel_list <- c("All", sort(unique(cars$Fuel_Type)))
trans_list <- c("All", sort(unique(cars$Transmission)))
owner_list <- c("All", sort(unique(cars$Owner_Type)))

ui <- fluidPage(
  tags$head(
    tags$title("CarVista | Used Car Price Analytics"),
    tags$link(rel="preconnect", href="https://fonts.googleapis.com"),
    tags$link(rel="preconnect", href="https://fonts.gstatic.com", crossorigin=""),
    tags$link(href="https://fonts.googleapis.com/css2?family=DM+Sans:wght@400;500;600;700&family=Patrick+Hand&display=swap", rel="stylesheet"),
    tags$link(rel="stylesheet", href="styles.css")
  ),
  div(class="app",
    div(class="topbar",
      div(class="logo-wrap",
        div(class="car-logo","🚙"),
        div(div(class="logo-title","CarVista"),div(class="logo-sub","USED CAR PRICE ANALYTICS"))
      ),
      div(class="nav",
        actionLink("nav_overview","⌂ Overview",class="nav-item active"),
        actionLink("nav_explore","🚗 Explore Cars",class="nav-item"),
        actionLink("nav_price","▥ Price Analysis",class="nav-item"),
        actionLink("nav_insights","💡 Insights",class="nav-item"),
        actionLink("nav_reco","★ Car Recommender",class="nav-item"),
        actionLink("nav_data","▤ Data Explorer",class="nav-item")
      )
    ),

    div(class="hero",
      div(class="road doodle-road"),
      div(class="hero-copy",
        div(class="hero-kicker","USED CAR INTELLIGENCE"),
        h1("Used Car Price Analytics"),
        p("Make smarter decisions. Drive better value."),
        div(class="hero-chips",span("Find"),span("Analyse"),span("Compare"),span("Choose"))
      ),
      div(class="hero-car","🚙"),
      div(class="hero-note","Explore market trends,\ncompare prices & find\nyour next car!")
    ),

    div(class="main-grid",
      div(class="sidebar",
        div(class="filter-title","⌕  FILTER CARS"),
        div(class="filter-block",selectInput("brand","Brand",brand_list)),
        div(class="filter-block",selectInput("model","Model",model_list)),
        div(class="filter-block",selectInput("fuel","Fuel Type",fuel_list)),
        div(class="filter-block",selectInput("trans","Transmission",trans_list)),
        div(class="filter-block",selectInput("owner","Owner Type",owner_list)),
        div(class="filter-block",sliderInput("year","Year",min=min(cars$Year),max=max(cars$Year),value=c(min(cars$Year),max(cars$Year)),sep="")),
        div(class="filter-block",sliderInput("price","Price (₹)",min=0,max=5000000,value=c(0,5000000),step=50000)),
        div(class="filter-block",sliderInput("km","Kilometers Driven",min=0,max=230000,value=c(0,230000),step=5000)),
        actionButton("apply","Apply Filters  →",class="apply-btn"),
        div(class="side-tip","TIP  •  Use the filters to build a custom market view.")
      ),

      div(class="workspace",
        div(class="section-nav",
          actionLink("sec_overview","Overview",class="section-link active"),
          actionLink("sec_explore","Explore Cars",class="section-link"),
          actionLink("sec_price","Price Analysis",class="section-link"),
          actionLink("sec_insights","Insights",class="section-link"),
          actionLink("sec_reco","Recommender",class="section-link"),
          actionLink("sec_data","Data Explorer",class="section-link")
        ),

        tabsetPanel(id="main_tabs", type="hidden",
          tabPanel("overview",
            div(class="kpi-grid",
              div(class="kpi kpi-blue",div(class="kpi-icon","🚗"),div(class="kpi-label","TOTAL CARS"),div(class="kpi-value",textOutput("n_cars")),div(class="kpi-change","Filtered inventory")),
              div(class="kpi kpi-green",div(class="kpi-icon","₹"),div(class="kpi-label","AVERAGE PRICE"),div(class="kpi-value",textOutput("avg_price")),div(class="kpi-change","Market average")),
              div(class="kpi kpi-yellow",div(class="kpi-icon","▣"),div(class="kpi-label","AVERAGE YEAR"),div(class="kpi-value",textOutput("avg_year")),div(class="kpi-change","Vehicle age signal")),
              div(class="kpi kpi-pink",div(class="kpi-icon","◌"),div(class="kpi-label","AVG KM DRIVEN"),div(class="kpi-value",textOutput("avg_km")),div(class="kpi-change","Usage indicator")),
              div(class="kpi kpi-purple",div(class="kpi-icon","★"),div(class="kpi-label","AVG RATING"),div(class="kpi-value",textOutput("avg_rating")),div(class="kpi-change","Customer sentiment"))
            ),
            div(class="chart-grid",
              div(class="panel large",div(class="panel-head",h3("Price by Brand — Top 10"),span("AVERAGE PRICE")),plotOutput("brand_plot",height="330px")),
              div(class="panel",div(class="panel-head",h3("Price Distribution"),span("MARKET SPREAD")),plotOutput("hist_plot",height="330px")),
              div(class="panel",div(class="panel-head",h3("Average Price by Year"),span("TREND")),plotOutput("year_plot",height="330px"))
            ),
            div(class="chart-grid lower",
              div(class="panel",div(class="panel-head",h3("Fuel Type Analysis"),span("MIX")),plotOutput("fuel_plot",height="270px")),
              div(class="panel",div(class="panel-head",h3("Transmission Analysis"),span("MIX")),plotOutput("trans_plot",height="270px")),
              div(class="panel",div(class="panel-head",h3("Owner Type Analysis"),span("OWNERSHIP")),plotOutput("owner_plot",height="270px"))
            )
          ),

          tabPanel("explore",
            div(class="page-head",h2("Explore Cars"),p("Compare the filtered inventory by brand, model, usage and location.")),
            div(class="insight-grid",
              div(class="mini-card",strong("Most listed brand"),span(textOutput("top_brand"))),
              div(class="mini-card",strong("Lowest average price"),span(textOutput("low_brand"))),
              div(class="mini-card",strong("Highest rated brand"),span(textOutput("best_rating_brand")))
            ),
            div(class="chart-grid",
              div(class="panel large",div(class="panel-head",h3("Brand inventory"),span("COUNT")),plotOutput("brand_count",height="350px")),
              div(class="panel",div(class="panel-head",h3("City market"),span("AVERAGE PRICE")),plotOutput("city_plot",height="350px"))
            )
          ),

          tabPanel("price",
            div(class="page-head",h2("Price Analysis"),p("Understand the relationship between age, mileage and resale value.")),
            div(class="chart-grid",
              div(class="panel large",div(class="panel-head",h3("Price vs. Kilometers Driven"),span("USAGE")),plotOutput("scatter_km",height="360px")),
              div(class="panel",div(class="panel-head",h3("Price by Owner Type"),span("OWNERSHIP")),plotOutput("owner_price",height="360px"))
            ),
            div(class="panel",div(class="panel-head",h3("Fuel Type vs Average Price"),span("FUEL")),plotOutput("fuel_price",height="300px"))
          ),

          tabPanel("insights",
            div(class="page-head",h2("Market Insights"),p("Quick signals generated from the current selection.")),
            div(class="insight-banner",div(class="big-insight",textOutput("insight_text")),div(class="scribble","DATA → DECISION")),
            div(class="chart-grid",
              div(class="panel",div(class="panel-head",h3("Automatic vs Manual"),span("PRICE")),plotOutput("trans_price",height="310px")),
              div(class="panel",div(class="panel-head",h3("Model value leaders"),span("TOP 10")),plotOutput("model_plot",height="310px")),
              div(class="panel",div(class="panel-head",h3("Rating distribution"),span("SENTIMENT")),plotOutput("rating_plot",height="310px"))
            )
          ),

          tabPanel("reco",
            div(class="page-head",h2("Car Recommender"),p("Enter your preferences and get a simple shortlist from the bundled dataset.")),
            div(class="reco-layout",
              div(class="reco-form panel",
                h3("Your preferences"),
                numericInput("budget","Maximum budget (₹)",value=800000,min=100000,max=5000000,step=50000),
                selectInput("reco_fuel","Preferred fuel",fuel_list),
                selectInput("reco_trans","Preferred transmission",trans_list),
                sliderInput("reco_year","Minimum year",min=min(cars$Year),max=max(cars$Year),value=2018,sep=""),
                sliderInput("reco_km","Maximum kilometers",min=0,max=230000,value=100000,step=5000),
                actionButton("recommend","Find my cars ✦",class="apply-btn")
              ),
              div(class="panel",div(class="panel-head",h3("Recommended shortlist"),span("BEST MATCHES")),DTOutput("recommend_table"))
            )
          ),

          tabPanel("data",
            div(class="page-head",h2("Data Explorer"),p("Search, sort and download the underlying used-car dataset.")),
            div(class="table-panel",DTOutput("cars_table"))
          )
        )
      )
    ),
    div(class="footer",strong("CARVISTA"),span("Used Car Price Analytics • R + Shiny"))
  ),

  tags$script(HTML("
    $(function(){
      function go(tab){
        $('#main_tabs li').each(function(){
          if($(this).text().trim().toLowerCase()===tab){
            $(this).find('a').trigger('click');
          }
        });
        $('.nav-item,.section-link').removeClass('active');
        $('.nav-item').filter(function(){return $(this).text().toLowerCase().indexOf(tab)>-1 || (tab==='reco' && $(this).text().toLowerCase().indexOf('recommender')>-1);}).addClass('active');
        $('.section-link').filter(function(){return $(this).text().toLowerCase().indexOf(tab)>-1 || (tab==='reco' && $(this).text().toLowerCase().indexOf('recommender')>-1);}).addClass('active');
        window.scrollTo({top:0,behavior:'smooth'});
      }
      $('.nav-item').on('click',function(e){e.preventDefault(); var t=$(this).text().toLowerCase(); if(t.indexOf('overview')>-1)go('overview'); else if(t.indexOf('explore')>-1)go('explore'); else if(t.indexOf('price')>-1)go('price'); else if(t.indexOf('insights')>-1)go('insights'); else if(t.indexOf('recommender')>-1)go('reco'); else go('data');});
      $('.section-link').on('click',function(e){e.preventDefault(); var t=$(this).text().toLowerCase(); if(t.indexOf('overview')>-1)go('overview'); else if(t.indexOf('explore')>-1)go('explore'); else if(t.indexOf('price')>-1)go('price'); else if(t.indexOf('insights')>-1)go('insights'); else if(t.indexOf('recommender')>-1)go('reco'); else go('data');});
    });
  "))
)

server <- function(input, output, session){
  filtered <- eventReactive(input$apply, {
    x <- cars
    if(input$brand!="All") x <- x[x$Brand==input$brand,]
    if(input$model!="All") x <- x[x$Model==input$model,]
    if(input$fuel!="All") x <- x[x$Fuel_Type==input$fuel,]
    if(input$trans!="All") x <- x[x$Transmission==input$trans,]
    if(input$owner!="All") x <- x[x$Owner_Type==input$owner,]
    x <- x[x$Year>=input$year[1] & x$Year<=input$year[2],]
    x <- x[x$Price>=input$price[1] & x$Price<=input$price[2],]
    x <- x[x$Kilometers_Driven>=input$km[1] & x$Kilometers_Driven<=input$km[2],]
    x
  }, ignoreNULL=FALSE)

  output$n_cars <- renderText(comma(nrow(filtered())))
  output$avg_price <- renderText(dollar(mean(filtered()$Price),prefix="₹",accuracy=1,big.mark=","))
  output$avg_year <- renderText(sprintf("%.0f",mean(filtered()$Year)))
  output$avg_km <- renderText(comma(mean(filtered()$Kilometers_Driven),accuracy=1))
  output$avg_rating <- renderText(sprintf("%.1f / 5",mean(filtered()$Rating)))

  theme <- theme_minimal(base_family="DM Sans") + theme(panel.grid.minor=element_blank(),panel.grid.major.x=element_blank(),plot.title=element_blank())
  output$brand_plot <- renderPlot({
    x<-filtered()%>%group_by(Brand)%>%summarise(Price=mean(Price),.groups="drop")%>%arrange(desc(Price))%>%slice_head(n=10)
    ggplot(x,aes(reorder(Brand,Price),Price))+geom_col(width=.65)+coord_flip()+scale_y_continuous(labels=dollar_format(prefix="₹",big.mark=",",accuracy=100000))+labs(x=NULL,y=NULL)+theme
  })
  output$hist_plot <- renderPlot({
    ggplot(filtered(),aes(Price))+geom_histogram(bins=28,fill="#66A8E8",color="white")+scale_x_continuous(labels=dollar_format(prefix="₹",accuracy=100000))+labs(x="Price",y="Count")+theme
  })
  output$year_plot <- renderPlot({
    x<-filtered()%>%group_by(Year)%>%summarise(Price=mean(Price),.groups="drop")
    ggplot(x,aes(Year,Price))+geom_line(linewidth=1.2)+geom_point(size=2)+scale_y_continuous(labels=dollar_format(prefix="₹",accuracy=100000))+labs(x=NULL,y=NULL)+theme
  })
  output$fuel_plot <- renderPlot({
    x<-filtered()%>%count(Fuel_Type)
    ggplot(x,aes("",n,fill=Fuel_Type))+geom_col(width=1,color="white")+coord_polar("y")+theme_void()+theme(legend.position="bottom",text=element_text(family="DM Sans"))
  })
  output$trans_plot <- renderPlot({
    x<-filtered()%>%count(Transmission)
    ggplot(x,aes("",n,fill=Transmission))+geom_col(width=1,color="white")+coord_polar("y")+theme_void()+theme(legend.position="bottom",text=element_text(family="DM Sans"))
  })
  output$owner_plot <- renderPlot({
    x<-filtered()%>%count(Owner_Type)
    ggplot(x,aes(reorder(Owner_Type,n),n))+geom_col(width=.65)+labs(x=NULL,y="Cars")+theme
  })
  output$brand_count <- renderPlot({
    x<-filtered()%>%count(Brand,sort=TRUE)%>%slice_head(n=10)
    ggplot(x,aes(reorder(Brand,n),n))+geom_col(width=.65)+coord_flip()+labs(x=NULL,y="Cars")+theme
  })
  output$city_plot <- renderPlot({
    x<-filtered()%>%group_by(City)%>%summarise(Price=mean(Price),.groups="drop")%>%arrange(desc(Price))
    ggplot(x,aes(reorder(City,Price),Price))+geom_col(width=.65)+coord_flip()+scale_x_discrete()+scale_y_continuous(labels=dollar_format(prefix="₹",accuracy=100000))+labs(x=NULL,y=NULL)+theme
  })
  output$scatter_km <- renderPlot({
    x<-filtered()%>%slice_sample(n=min(nrow(filtered()),800))
    ggplot(x,aes(Kilometers_Driven,Price))+geom_point(alpha=.38,size=2)+geom_smooth(method="lm",se=FALSE,linewidth=1)+scale_y_continuous(labels=dollar_format(prefix="₹",accuracy=100000))+labs(x="Kilometers Driven",y="Price")+theme
  })
  output$owner_price <- renderPlot({
    x<-filtered()%>%group_by(Owner_Type)%>%summarise(Price=mean(Price),.groups="drop")
    ggplot(x,aes(reorder(Owner_Type,Price),Price))+geom_col(width=.65)+scale_y_continuous(labels=dollar_format(prefix="₹",accuracy=100000))+labs(x=NULL,y=NULL)+theme
  })
  output$fuel_price <- renderPlot({
    x<-filtered()%>%group_by(Fuel_Type)%>%summarise(Price=mean(Price),.groups="drop")
    ggplot(x,aes(reorder(Fuel_Type,Price),Price))+geom_col(width=.65)+scale_y_continuous(labels=dollar_format(prefix="₹",accuracy=100000))+labs(x=NULL,y=NULL)+theme
  })
  output$trans_price <- renderPlot({
    x<-filtered()%>%group_by(Transmission)%>%summarise(Price=mean(Price),.groups="drop")
    ggplot(x,aes(reorder(Transmission,Price),Price))+geom_col(width=.65)+scale_y_continuous(labels=dollar_format(prefix="₹",accuracy=100000))+labs(x=NULL,y=NULL)+theme
  })
  output$model_plot <- renderPlot({
    x<-filtered()%>%group_by(Model)%>%summarise(Price=mean(Price),.groups="drop")%>%arrange(desc(Price))%>%slice_head(n=10)
    ggplot(x,aes(reorder(Model,Price),Price))+geom_col(width=.65)+coord_flip()+scale_x_discrete()+scale_y_continuous(labels=dollar_format(prefix="₹",accuracy=100000))+labs(x=NULL,y=NULL)+theme
  })
  output$rating_plot <- renderPlot({
    ggplot(filtered(),aes(Rating))+geom_histogram(bins=10,fill="#F2A65A",color="white")+scale_x_continuous(breaks=seq(3,5,.5))+labs(x="Rating",y="Cars")+theme
  })
  output$top_brand <- renderText({
    x<-filtered()%>%count(Brand,sort=TRUE); if(nrow(x)) x$Brand[1] else "—"
  })
  output$low_brand <- renderText({
    x<-filtered()%>%group_by(Brand)%>%summarise(p=mean(Price),.groups="drop")%>%arrange(p); if(nrow(x)) paste0(x$Brand[1]," • ",dollar(x$p[1],prefix="₹",accuracy=1000)) else "—"
  })
  output$best_rating_brand <- renderText({
    x<-filtered()%>%group_by(Brand)%>%summarise(r=mean(Rating),.groups="drop")%>%arrange(desc(r)); if(nrow(x)) paste0(x$Brand[1]," • ",sprintf("%.1f/5",x$r[1])) else "—"
  })
  output$insight_text <- renderText({
    x<-filtered()
    if(!nrow(x)) return("No cars match the current filters.")
    best <- x%>%group_by(Brand)%>%summarise(p=mean(Price),r=mean(Rating),.groups="drop")%>%arrange(desc(r))%>%slice_head(n=1)
    paste0(best$Brand," leads the filtered market on average rating at ",sprintf("%.1f/5",best$r),
           ". The current average listing price is ",dollar(mean(x$Price),prefix="₹",accuracy=1000),
           " across ",comma(nrow(x))," cars.")
  })

  output$recommend_table <- renderDT({
    x<-cars
    if(input$reco_fuel!="All") x<-x[x$Fuel_Type==input$reco_fuel,]
    if(input$reco_trans!="All") x<-x[x$Transmission==input$reco_trans,]
    x<-x[x$Price<=input$budget & x$Year>=input$reco_year & x$Kilometers_Driven<=input$reco_km,]
    if(nrow(x)==0) return(datatable(data.frame(Message="No exact matches. Relax one preference."),rownames=FALSE,options=list(dom="t")))
    x$Score <- round(100 - (x$Price/input$budget*35) + ((x$Year-2009)/16*25) - (x$Kilometers_Driven/230000*20) + x$Rating*8,1)
    x<-x%>%arrange(desc(Score))%>%slice_head(n=10)%>%select(Brand,Model,Year,Fuel_Type,Transmission,Kilometers_Driven,Price,Rating,Score)
    datatable(x,rownames=FALSE,options=list(pageLength=10,scrollX=TRUE))
  })

  output$cars_table <- renderDT({
    datatable(filtered(),rownames=FALSE,filter="top",options=list(pageLength=12,scrollX=TRUE))
  })

  observeEvent(input$nav_overview,{updateTabsetPanel(session,"main_tabs","overview")})
  observeEvent(input$nav_explore,{updateTabsetPanel(session,"main_tabs","explore")})
  observeEvent(input$nav_price,{updateTabsetPanel(session,"main_tabs","price")})
  observeEvent(input$nav_insights,{updateTabsetPanel(session,"main_tabs","insights")})
  observeEvent(input$nav_reco,{updateTabsetPanel(session,"main_tabs","reco")})
  observeEvent(input$nav_data,{updateTabsetPanel(session,"main_tabs","data")})
  observeEvent(input$sec_overview,{updateTabsetPanel(session,"main_tabs","overview")})
  observeEvent(input$sec_explore,{updateTabsetPanel(session,"main_tabs","explore")})
  observeEvent(input$sec_price,{updateTabsetPanel(session,"main_tabs","price")})
  observeEvent(input$sec_insights,{updateTabsetPanel(session,"main_tabs","insights")})
  observeEvent(input$sec_reco,{updateTabsetPanel(session,"main_tabs","reco")})
  observeEvent(input$sec_data,{updateTabsetPanel(session,"main_tabs","data")})
}

shinyApp(ui,server)
