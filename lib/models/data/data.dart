import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

List<Map<String, dynamic>> transactionData = [
  {
    'icon': FontAwesomeIcons.burger,
    'name': 'Food',
    'totalAmount': '-£45.00',
    'date': 'Today',
  },

  {
    'icon': FontAwesomeIcons.bagShopping,
    'name': 'Shopping',
    'totalAmount': '-£743.00',
    'date': 'Today',
  },
  {
    'icon': FontAwesomeIcons.heartCircleCheck,
    'name': 'Health',
    'totalAmount': '-£293.00',
    'date': 'yesterday',
  },
  {
    'icon': FontAwesomeIcons.car,
    'name': 'Road Tax',
    'totalAmount': '-£93.00',
    'date': 'yesterday',
  },
  {
    'icon': FontAwesomeIcons.plane,
    'name': 'Travel',
    'totalAmount': '-£63.00',
    'date': 'yesterday',
  },
  {
    'icon': FontAwesomeIcons.graduationCap,
    'name': 'Education',
    'totalAmount': '-£93.00',
    'date': 'yesterday',
  },
];

List<Map<String, dynamic>> AvailableIcons = [
  {'icon': FontAwesomeIcons.briefcase, 'name': 'work'},
  {'icon': FontAwesomeIcons.person, 'name': 'person'},
  {
    'icon': FontAwesomeIcons.triangleExclamation,
    'name': 'warning',
  },
  {
    'icon': FontAwesomeIcons.dumbbell,
    'name': 'fitness centre',
  },
  {'icon': FontAwesomeIcons.book, 'name': 'book'},
  {
    'icon': FontAwesomeIcons.graduationCap,
    'name': 'Education',
  },
  {'icon': FontAwesomeIcons.burger, 'name': 'food'},
  {
    'icon': FontAwesomeIcons.bagShopping,
    'name': 'Shopping',
  },
  {
    'icon': FontAwesomeIcons.heartCircleCheck,
    'name': 'Health',
  },
  {'icon': FontAwesomeIcons.car, 'name': 'Road Tax'},
  {'icon': FontAwesomeIcons.plane, 'name': 'Travel'},
  {
    'icon': FontAwesomeIcons.houseChimney,
    'name': 'utilities',
  },
  {'icon': FontAwesomeIcons.mobile, 'name': 'pets'},
  {'icon': FontAwesomeIcons.church, 'name': 'pets'},
  {'icon': FontAwesomeIcons.film, 'name': 'pets'},
  {'icon': FontAwesomeIcons.children, 'name': 'pets'},
  {'icon': FontAwesomeIcons.mosque, 'name': 'pets'},
  {
    'icon': FontAwesomeIcons.moneyBillTrendUp,
    'name': 'salary',
  },
  {'icon': FontAwesomeIcons.gifts, 'name': 'gifts'},
  {'icon': FontAwesomeIcons.paw, 'name': 'pets'},
];

final List<Map<String, dynamic>> tips = [
  {
    'title': '10 Ways to Save on a Budget',
    'image': 'assets/images/tip_budget.png',
    'description':
        'Here are some practical tips you can apply to improve your budget and financial goals. Stay consistent, track your spending, and make informed decisions daily.',
    'tips':
        '1. Track your spending daily\n'
        '2. Separate needs vs wants\n'
        '3. Set savings goals\n'
        '4. Cancel unused subscriptions\n'
        '5. Cook at home more often\n'
        '6. Compare prices before big purchases\n'
        '7. Use cash instead of credit\n'
        '8. Avoid impulse buying\n'
        '9. Automate your savings\n'
        '10. Review your budget monthly',
  },
  {
    'title': 'Track Where Your Money Goes',
    'image': 'assets/images/track_budget.png',
    'description':
        'Understanding your spending is the first step toward better money control.',
    'tips':
        '1. Categorize all expenses\n'
        '2. Identify unnecessary costs\n'
        '3. Monitor recurring payments\n'
        '4. Use a budgeting app\n'
        '5. Set weekly review sessions',
  },
  {
    'title': 'Take Hold of Your Finances',
    'image': 'assets/images/control_finance.png',
    'description':
        'Build confidence with your money by making informed, intentional decisions every month.',
    'tips':
        '1. Review your monthly income and expenses\n'
        '2. Create a realistic and detailed budget\n'
        '3. Set clear short-term and long-term financial goals\n'
        '4. Cut unnecessary spending without depriving yourself\n'
        '5. Use budgeting apps or spreadsheets to track progress\n'
        '6. Build an emergency fund with at least 3 months of expenses\n'
        '7. Pay off high-interest debt first\n'
        '8. Avoid lifestyle inflation as your income increases\n'
        '9. Check your credit score regularly\n'
        '10. Reflect monthly on your progress and adjust where needed',
  },
  {
    'title': 'Build an Emergency Fund',
    'image': 'assets/images/emergency.png',
    'description':
        'An emergency fund protects you from unexpected expenses without relying on credit or loans.',
    'tips':
        '1. Set a goal of 3–6 months of living expenses\n'
        '2. Start with small, consistent contributions\n'
        '3. Automate transfers to your savings account\n'
        '4. Use a separate, easy-access savings account\n'
        '5. Avoid dipping into it for non-emergencies\n'
        '6. Cut back temporarily to boost your savings rate\n'
        '7. Save windfalls like tax refunds or bonuses\n'
        '8. Track your progress monthly\n'
        '9. Replenish the fund after any withdrawals\n'
        '10. Treat it as a top priority in your budget',
  },
  {
    'title': 'Review Your Budget Monthly',
    'image': 'assets/images/monthly.png',
    'description':
        'Regularly reviewing your budget helps you stay on track and adjust to changes in your income or expenses.',
    'tips':
        '1. Set a fixed date each month for review\n'
        '2. Compare actual vs planned spending\n'
        '3. Identify areas of overspending\n'
        '4. Update goals based on current priorities\n'
        '5. Adjust categories where needed\n'
        '6. Reflect on unexpected expenses\n'
        '7. Reallocate leftover funds to savings\n'
        '8. Celebrate budgeting wins\n'
        '9. Track trends over time\n'
        '10. Keep it simple and consistent',
  },
  {
    'title': 'Cut Unnecessary Expenses',
    'image': 'assets/images/cut.png',
    'description':
        'Trimming the fat from your budget frees up more money for what truly matters—like saving, investing, or paying off debt.',
    'tips':
        '1. Cancel unused subscriptions\n'
        '2. Reduce dining out frequency\n'
        '3. Buy generic brands\n'
        '4. Limit online shopping\n'
        '5. Avoid convenience store purchases\n'
        '6. Unplug electronics when not in use\n'
        '7. Reevaluate gym or club memberships\n'
        '8. Make coffee at home\n'
        '9. Cut down on impulse buys\n'
        '10. Wait 24 hours before big purchases',
  },
  {
    'title': 'Automate Your Savings',
    'image': 'assets/images/automate.png',
    'description':
        'Setting up automatic transfers ensures you consistently save without thinking about it—making saving a habit, not a chore.',
    'tips':
        '1. Set up auto-transfer to savings on payday\n'
        '2. Use apps that round up your purchases\n'
        '3. Automate emergency fund contributions\n'
        '4. Schedule recurring investments monthly\n'
        '5. Split direct deposit between accounts\n'
        '6. Increase auto-savings with each raise\n'
        '7. Set calendar reminders to review goals\n'
        '8. Use separate accounts for different goals\n'
        '9. Automate credit card payments too\n'
        '10. Review auto-savings every quarter',
  },
  {
    'title': 'Use the 50/30/20 Rule',
    'image': 'assets/images/50rule.png',
    'description':
        'The 50/30/20 rule is a simple budgeting method that divides your income into needs, wants, and savings. It helps you prioritize and maintain balance.',
    'tips':
        '1. Allocate 50% of income to essentials (rent, food, utilities)\n'
        '2. Allocate 30% to personal wants and lifestyle\n'
        '3. Allocate 20% to savings and debt repayment\n'
        '4. Review your income and adjust categories\n'
        '5. Track expenses weekly to stay within limits\n'
        '6. Use budget apps with category breakdowns\n'
        '7. Reassess when income or expenses change\n'
        '8. Apply this rule monthly for consistency\n'
        '9. In high-cost areas, tweak percentages slightly\n'
        '10. Stick with it—it builds financial discipline',
  },
  {
    'title': 'Pay Off Debt Strategically',
    'image': 'assets/images/payoff.png',
    'description':
        'Managing debt wisely helps you save on interest and reduce financial stress. Strategic payoff gives you long-term control over your finances.',
    'tips':
        '1. List all debts with balances and interest rates\n'
        '2. Prioritize high-interest debts first (avalanche method)\n'
        '3. Alternatively, clear small debts first for motivation (snowball method)\n'
        '4. Set monthly debt payment goals\n'
        '5. Avoid taking on new unnecessary debt\n'
        '6. Consolidate debts if it lowers your interest\n'
        '7. Make more than the minimum payment when possible\n'
        '8. Track your payoff progress monthly\n'
        '9. Reduce lifestyle costs and apply savings to debt\n'
        '10. Celebrate milestones to stay motivated',
  },

  {
    'title': 'Budget With a Purpose',
    'image': 'assets/images/purpose.png',
    'description':
        'A purposeful budget keeps your spending aligned with your goals. It helps you make intentional decisions instead of reactive ones.',
    'tips':
        '1. Define clear short- and long-term financial goals\n'
        '2. Assign every pound a purpose — income minus expenses = zero\n'
        '3. Prioritize spending on essentials and value-aligned items\n'
        '4. Include savings and investments as key budget items\n'
        '5. Set limits for non-essentials to avoid emotional spending\n'
        '6. Use goal-based categories like travel, education, or home\n'
        '7. Review and adjust monthly based on performance\n'
        '8. Keep visual reminders of your goals for motivation\n'
        '9. Share goals with a partner or accountability buddy\n'
        '10. Celebrate when you hit budgeting milestones',
  },
];
