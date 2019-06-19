import 'dart:collection';
import 'package:expression_language/expression_language.dart';
import 'package:expression_language/src/visitors/expression_visitor.dart';

class CloneExpressionVisitor extends ExpressionVisitor {
  final Map<String, ExpressionProviderElement> _expressionProviderElementMap;
  final Queue<Expression> _expressionStack = Queue<Expression>();

  CloneExpressionVisitor(this._expressionProviderElementMap);

  void push(Expression expression) {
    _expressionStack.addLast(expression);
  }

  Expression pop() {
    return _expressionStack.removeLast();
  }

  Expression get result => _expressionStack.first;

  @override
  void visitConditionalExpression<T>(ConditionalExpression<T> expression) {
    expression.condition.accept(this);
    expression.trueValue.accept(this);
    expression.falseValue.accept(this);
    var falseValue = pop();
    var trueValue = pop();
    var condition = pop();
    push(ConditionalExpression<T>(condition, trueValue, falseValue));
  }

  @override
  void visitConstant<T>(ConstantExpression<T> expression) {
    push(ConstantExpression<T>(expression.value));
  }

  @override
  void visitDelegate<T>(DelegateExpression<T> expression) {
    var expressionPath = expression.expressionPath;
    var expressionProviderElement =
        _expressionProviderElementMap[expressionPath[0]];
    ExpressionProvider expressionProvider;
    if (expressionPath.length == 1) {
      expressionProvider = expressionProviderElement.getExpressionProvider();
      push(DelegateExpression<T>(expressionPath, expressionProvider));
      return;
    }
    for (var i = 1; i < expressionPath.length; i++) {
      var propertyName = expressionPath[i];
      expressionProvider =
          expressionProviderElement.getExpressionProvider(propertyName);
      if (expressionProvider is ExpressionProvider<ExpressionProviderElement>) {
        expressionProviderElement =
            expressionProvider.getExpression().evaluate();
      }
    }
    push(DelegateExpression<T>(expressionPath, expressionProvider));
  }

  @override
  void visitEqualBool(EqualBoolExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(EqualBoolExpression(left, right));
  }

  @override
  void visitEqualNumber(EqualNumberExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(EqualNumberExpression(left, right));
  }

  @override
  void visitDivision(DivisionExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(DivisionExpression(left, right));
  }

  @override
  void visitEqualString(EqualStringExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(EqualStringExpression(left, right));
  }

  @override
  void visitNotEqualBool(NotEqualBoolExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(NotEqualBoolExpression(left, right));
  }

  @override
  void visitNotEqualNumber(NotEqualNumberExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(NotEqualNumberExpression(left, right));
  }

  @override
  void visitNotEqualString(NotEqualStringExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(NotEqualStringExpression(left, right));
  }

  @override
  void visitLengthFunction(LengthFunctionExpression expression) {
    expression.value.accept(this);
    push(LengthFunctionExpression(pop()));
  }

  @override
  void visitLessThan(LessThanExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(LessThanExpression(left, right));
  }

  @override
  void visitLessThanOrEqual(LessThanOrEqualExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(LessThanOrEqualExpression(left, right));
  }

  @override
  void visitLogicalAnd(LogicalAndExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(LogicalAndExpression(left, right));
  }

  @override
  void visitLogicalOr(LogicalOrExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(LogicalOrExpression(left, right));
  }

  @override
  void visitNegateBool(NegateBoolExpression expression) {
    expression.value.accept(this);
    push(NegateBoolExpression(pop()));
  }

  @override
  void visitMultiply(MultiplyExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(MultiplyExpression(left, right));
  }

  @override
  void visitModulo(ModuloExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(ModuloExpression(left, right));
  }

  @override
  void visitMutable<T>(MutableExpression<T> expression) {
    push(MutableExpression(expression.value));
  }

  @override
  void visitImmutable<T>(ImmutableExpression<T> expression) {
    push(ImmutableExpression(expression.value));
  }

  @override
  void visitPlusNumber(PlusNumberExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(PlusNumberExpression(left, right));
  }

  @override
  void visitMinusNumber(MinusNumberExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(MinusNumberExpression(left, right));
  }

  @override
  void visitPlusString(PlusStringExpression expression) {
    expression.left.accept(this);
    expression.right.accept(this);
    var right = pop();
    var left = pop();
    push(PlusStringExpression(left, right));
  }

  @override
  void visitNegateNumber(NegateNumberExpression expression) {
    expression.value.accept(this);
    push(NegateNumberExpression(pop()));
  }

  @override
  void visitToStringFunction(ToStringFunctionExpression expression) {
    expression.value.accept(this);
    push(ToStringFunctionExpression(pop()));
  }

  @override
  void visitListCountFunction<T>(ListCountFunctionExpression<T> expression) {
    expression.value.accept(this);
    push(ListCountFunctionExpression(pop()));
  }
}