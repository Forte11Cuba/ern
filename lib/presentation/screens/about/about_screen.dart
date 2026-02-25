import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/l10n/generated/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../../../domain/calculators/cognitive_risk_calculator.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l.about)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- Author card ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/author.jpeg'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.authorName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l.formulaAuthor,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.coAuthor,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.link, size: 16),
                        label: const Text('ORCID'),
                        onPressed: () => _launchUrl('https://orcid.org/0000-0002-8723-3733'),
                      ),
                      const SizedBox(width: 8),
                      ActionChip(
                        avatar: const Icon(Icons.link, size: 16),
                        label: const Text('ResearchGate'),
                        onPressed: () => _launchUrl('https://www.researchgate.net/profile/Julio-Esquivel-Tamayo'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    l.authorContact,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: () => _launchUrl('mailto:julioantesquivel@gmail.com'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'julioantesquivel@gmail.com',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _launchUrl('https://wa.me/5355884948'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          size: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '+53 5588 4948',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'WhatsApp',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Scale description ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.aboutTheScale,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(l.scaleDescription),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    l.scaleParameters,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _paramRow(context, l.range,
                      '0 - ${CognitiveRiskCalculator.maxScore}'),
                  _paramRow(context, l.cutoffPoint,
                      '${CognitiveRiskCalculator.cutoff}'),
                  _paramRow(context, l.categories,
                      '${l.lowRisk} / ${l.highRisk}'),
                  _paramRow(context, l.factors, '9'),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    l.weightsPerFactor,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _factorRow(context, l.lowCompetence, 'lowCompetence', l),
                  _factorRow(context, l.hypertension, 'hypertension', l),
                  _factorRow(context, l.covid, 'covid', l),
                  _factorRow(context, l.lowEducation, 'lowEducation', l),
                  _factorRow(context, l.obesity, 'obesity', l),
                  _factorRow(context, l.diabetes, 'diabetes', l),
                  _factorRow(context, l.weightLoss, 'weightLoss', l),
                  _factorRow(context, l.inactivity, 'inactivity', l),
                  _factorRow(context, l.smoking, 'smoking', l),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Scientific evidence ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.science_outlined,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        l.scientificEvidence,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l.validationMetrics,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  _metricRow(context, l.sensitivity, '88'),
                  _metricRow(context, l.specificity, '95.5'),
                  _metricRow(context, l.ppv, '90.72'),
                  _metricRow(context, l.npv, '94.08'),
                  _metricRow(context, l.youdenIndex, '0.835'),
                  _metricRow(context, l.positiveLR, '19.56'),
                  _metricRow(context, l.negativeLR, '0.051'),
                  _metricRow(context, l.aucRoc, '0.918'),
                  _metricRow(context, l.aucRocCI, '0.877 - 0.958'),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),
                  Text(
                    l.scientificReferences,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 12),
                  // Citation 1
                  _CitationCard(
                    citation: l.citation1,
                    doi: 'DOI: 10.24875/RMN.25000011',
                    url: 'https://www.revmexneurociencia.com/frame_eng.php?id=289',
                    viewLabel: l.viewArticle,
                  ),
                  const SizedBox(height: 8),
                  // Citation 2
                  _CitationCard(
                    citation: l.citation2,
                    doi: 'DOI: 10.24875/ANC.25000057',
                    url: 'https://www.doi.org/10.24875/ANC.25000057',
                    viewLabel: l.viewArticle,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // --- Developer ---
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.code,
                          color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        l.developer,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: Icon(Icons.person,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer),
                    ),
                    title: Text(
                      l.developerName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: const Text('github.com/Forte11Cuba'),
                    trailing: IconButton(
                      icon: const Icon(Icons.open_in_new),
                      onPressed: () => _launchUrl(
                          'https://github.com/Forte11Cuba'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // --- Version & footer ---
          Center(
            child: Column(
              children: [
                Text(
                  '${l.version} 1.0.0',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  l.clinicalUseOnly,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _factorRow(
      BuildContext context, String label, String key, AppLocalizations l) {
    return _paramRow(
      context,
      label,
      '${CognitiveRiskCalculator.factorWeights[key]} ${l.points}',
    );
  }

  Widget _paramRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _metricRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(child: Text(label)),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _CitationCard extends StatelessWidget {
  final String citation;
  final String doi;
  final String url;
  final String viewLabel;

  const _CitationCard({
    required this.citation,
    required this.doi,
    required this.url,
    required this.viewLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            citation,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  doi,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri,
                        mode: LaunchMode.externalApplication);
                  }
                },
                icon: const Icon(Icons.open_in_new, size: 14),
                label: Text(viewLabel, style: const TextStyle(fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
