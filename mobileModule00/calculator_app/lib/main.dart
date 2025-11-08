import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
		scaffoldBackgroundColor: Colors.blueGrey.shade700
      ),
      home: const MyHomePage(title: 'Calculator'),
    );
  }
}
// Source - https://stackoverflow.com/a␍
// Posted by jerrymouse, modified by community. See post 'Timeline' for change history␍
// Retrieved 2025-11-14, License - CC BY-SA 4.0␍

String strip(String str, String charactersToRemove){
  String escapedChars = RegExp.escape(charactersToRemove);
  RegExp regex = RegExp(r"^["+escapedChars+r"]+|["+escapedChars+r']+$');
  String newStr = str.replaceAll(regex, '').trim();
  return newStr;
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> {

	void resolveExpression() {
		try {
			ExpressionParser parser = GrammarParser();
			Expression expression = parser.parse(this.expression);

			RealEvaluator evaluator = RealEvaluator();
			num result = evaluator.evaluate(expression);

			setState(() {
				this.expression = '0';
				if (result.ceil() == result) {
					this.result = '$result'.substring(0, '$result'.length - 2);
				} else {
					this.result = '$result';
				}
			});
		} catch (e){
			setState(() {
				result = 'Error';			  
			});
		}
	}

	TextButton buildButton(String el) {
		if (['C', 'AC'].contains(el)) {
			return TextButton( 
				onPressed: () {
					setState(() {
						if (el == "AC") {expression = "0"; result = "0";}
						else { expression = expression == "0" ? expression : ( expression.length - 1 == 0 ? "0" : expression.substring(0, expression.length - 1) ); }
					});
				},
				style: ButtonStyle(
					backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
					foregroundColor: WidgetStateProperty.all(Colors.red),
					shape: WidgetStateProperty.all(ContinuousRectangleBorder()),
				),
				child: Text(el)
			);
		} else if (['+', '=', '-', '/', 'x'].contains(el)){
			return TextButton( 
				onPressed: () {
					setState(() {
						if (el == '=') {
							resolveExpression();
							return ;
						}
						else if ( el == 'x' ) { expression += '*'; }
						else { expression += el; }
						expression = strip(expression, "0.");
						if (expression.isEmpty) {
							expression = '0';
						}
					});
				},
				style: ButtonStyle(
					backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
					foregroundColor: WidgetStateProperty.all(Colors.white),
					shape: WidgetStateProperty.all(ContinuousRectangleBorder()),
				),
				child: Text(el)
			);
		} else {
			return TextButton( 
				onPressed: () {
					setState(() {
						if (el == '0' && expression == '0') return ;
						expression += el;
						if (expression.isEmpty) {
							expression = '0';
						}
					});
				},
				style: ButtonStyle(
					backgroundColor: WidgetStateProperty.all(Colors.blueGrey),
					foregroundColor: WidgetStateProperty.all(Colors.black),
					shape: WidgetStateProperty.all(ContinuousRectangleBorder()),
				),
				child: Text(el)
			);
		}
	}
	
	String result = "0";
	String expression = "0";

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
	List<Widget>buttons = List.from(
		["7", "8", "9", "C", "AC", "4", "5", "6", '+', '-', '1', '2', '3', 'x', '/', '.', '0', '00', '=', ''].map((el) { 
			return buildButton(el);
		})
	);
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Center(child: Text(widget.title)),
      ),
      body:
	  OrientationBuilder(builder: (context, orientation) {
		  return(
			  Column(
				  mainAxisAlignment: MainAxisAlignment.center,
				  children: [
					 Row(
						mainAxisAlignment: MainAxisAlignment.end,
						children: [
							Text(
							  expression,
							  style: Theme.of(context).textTheme.headlineLarge,
							),
						],
					 ),
					 Row(
						mainAxisAlignment: MainAxisAlignment.end,
						children: [
						   Text(
							 result,
							 style: Theme.of(context).textTheme.headlineLarge,
						   ),
						],
					 ),
					 Expanded( 
						child: Align(
							alignment: Alignment.bottomCenter,
							child: GridView.count(
								crossAxisCount: 5,
								shrinkWrap: true,
								childAspectRatio: orientation == Orientation.portrait ? 1 : 3,
								children: buttons
							)
						)
					 ),
				],
			)
		);
	  }
    )
	);
  }
}
